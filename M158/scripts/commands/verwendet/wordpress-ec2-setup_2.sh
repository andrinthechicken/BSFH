#!/bin/bash
# ============================================================
# WordPress EC2 Setup Script – Ubuntu 24.04
# Modul 158 – Migrationsprojekt
#
# Schritte:
#   1.  System aktualisieren
#   2.  Apache, PHP-FPM, MySQL installieren
#   3.  ZIP von S3 herunterladen und entpacken
#   4.  WordPress-Dateien nach /var/www/html kopieren
#   5.  MySQL Datenbank anlegen und SQL-Dump importieren
#   6.  wp-config.php aktualisieren
#   7.  Apache VirtualHost konfigurieren (mod_rewrite, PHP-FPM)
#   8.  PHP-FPM Pool konfigurieren
#   9.  phpMyAdmin installieren
#   10. SFTP-User anlegen
#   11. WP-CLI installieren
#   12. Berechtigungen setzen
#   13. Backup-Script + CRON-Job einrichten
#
# Log: /var/log/wordpress-setup.log
# ============================================================

exec > >(tee /var/log/wordpress-setup.log | logger -t wordpress-setup) 2>&1
set -e

# ------------------------------------------------------------
# KONFIGURATION
# ------------------------------------------------------------

S3_BUCKET="wordpress-backup-bsfh"
S3_KEY="wordpress.zip"

DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASSWORD="SicheresPasswort123!"
DB_HOST="localhost"

WP_DIR="/var/www/html"
SQL_FILE="wp_m158_db.sql"

DOMAIN="wordpress-server.dynv6.net"

# ------------------------------------------------------------

echo "================================================"
echo " WordPress EC2 Setup startet..."
echo "================================================"

# ------------------------------------------------------------
# SCHRITT 1: System aktualisieren
# ------------------------------------------------------------
echo ""
echo ">>> [1/13] System aktualisieren..."
apt-get update -y
apt-get upgrade -y

# ------------------------------------------------------------
# SCHRITT 2: Apache, PHP-FPM und MySQL installieren
# ------------------------------------------------------------
echo ""
echo ">>> [2/13] Apache, PHP-FPM, MySQL installieren..."
apt-get install -y \
  apache2 \
  mysql-server \
  php8.3-fpm \
  php8.3-mysql \
  php8.3-curl \
  php8.3-gd \
  php8.3-mbstring \
  php8.3-xml \
  php8.3-xmlrpc \
  php8.3-zip \
  php8.3-intl \
  php8.3-bcmath \
  php8.3-imagick \
  phpmyadmin \
  gnupg \
  unzip \
  awscli

systemctl start apache2
systemctl enable apache2
systemctl start mysql
systemctl enable mysql
systemctl start php8.3-fpm
systemctl enable php8.3-fpm

# ------------------------------------------------------------
# SCHRITT 3: ZIP von S3 herunterladen und entpacken
# ------------------------------------------------------------
echo ""
echo ">>> [3/13] ZIP von S3 herunterladen..."
aws s3 cp "s3://$S3_BUCKET/$S3_KEY" /tmp/wordpress.zip

echo ">>> ZIP entpacken..."
mkdir -p /tmp/wp-extract
unzip -o /tmp/wordpress.zip -d /tmp/wp-extract

# WordPress-Dateien finden (egal ob Unterordner oder direkt)
WP_SOURCE=$(find /tmp/wp-extract -name "wp-config.php" -maxdepth 3 | head -1 | xargs dirname)
echo ">>> WordPress-Dateien gefunden in: $WP_SOURCE"

# ------------------------------------------------------------
# SCHRITT 4: WordPress-Dateien kopieren
# ------------------------------------------------------------
echo ""
echo ">>> [4/13] WordPress-Dateien nach $WP_DIR kopieren..."
rm -f "$WP_DIR/index.html"
cp -r "$WP_SOURCE"/. "$WP_DIR/"

# ------------------------------------------------------------
# SCHRITT 5: MySQL Datenbank anlegen und SQL importieren
# ------------------------------------------------------------
echo ""
echo ">>> [5/13] Datenbank anlegen und SQL importieren..."

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

SQL_PATH=$(find /tmp/wp-extract -name "$SQL_FILE" | head -1)
if [ -n "$SQL_PATH" ]; then
  echo ">>> SQL-Datei gefunden: $SQL_PATH"
  mysql -u root "$DB_NAME" < "$SQL_PATH"
  echo ">>> Datenbank erfolgreich importiert!"
else
  echo ">>> WARNUNG: $SQL_FILE nicht gefunden!"
fi

# ------------------------------------------------------------
# SCHRITT 6: wp-config.php aktualisieren
# ------------------------------------------------------------
echo ""
echo ">>> [6/13] wp-config.php aktualisieren..."

WP_CONFIG="$WP_DIR/wp-config.php"

sed -i "s/define( *'DB_NAME', *'[^']*' *)/define('DB_NAME', '$DB_NAME')/" "$WP_CONFIG"
sed -i "s/define( *'DB_USER', *'[^']*' *)/define('DB_USER', '$DB_USER')/" "$WP_CONFIG"
sed -i "s/define( *'DB_PASSWORD', *'[^']*' *)/define('DB_PASSWORD', '$DB_PASSWORD')/" "$WP_CONFIG"
sed -i "s/define( *'DB_HOST', *'[^']*' *)/define('DB_HOST', '$DB_HOST')/" "$WP_CONFIG"

# WordPress-URLs auf Domain setzen
mysql -u root "$DB_NAME" << EOF
UPDATE wp_options SET option_value = 'http://$DOMAIN' WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value = 'http://$DOMAIN' WHERE option_name = 'home';
EOF

echo ">>> WordPress URL gesetzt auf: http://$DOMAIN"

# ------------------------------------------------------------
# SCHRITT 7: Apache VirtualHost mit PHP-FPM konfigurieren
# ------------------------------------------------------------
echo ""
echo ">>> [7/13] Apache VirtualHost konfigurieren..."

# Apache-Module aktivieren
a2enmod rewrite
a2enmod proxy_fcgi
a2enmod setenvif
a2enmod headers

cat > /etc/apache2/sites-available/wordpress.conf << EOF
<VirtualHost *:80>
    ServerName $DOMAIN
    ServerAlias www.$DOMAIN
    DocumentRoot $WP_DIR
    DirectoryIndex index.php index.html

    <Directory $WP_DIR>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    # PHP-FPM (Task 04)
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php/php8.3-fpm.sock|fcgi://localhost"
    </FilesMatch>

    ErrorLog \${APACHE_LOG_DIR}/wordpress-error.log
    CustomLog \${APACHE_LOG_DIR}/wordpress-access.log combined
</VirtualHost>
EOF

a2dissite 000-default.conf
a2ensite wordpress.conf

# ------------------------------------------------------------
# SCHRITT 8: PHP-FPM Pool konfigurieren
# ------------------------------------------------------------
echo ""
echo ">>> [8/13] PHP-FPM Pool konfigurieren..."

cat > /etc/php/8.3/fpm/pool.d/wordpress.conf << EOF
[wordpress]
user = www-data
group = www-data
listen = /run/php/php8.3-fpm.sock
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 10
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
pm.status_path = /fpm-status
EOF

# PHP-Limits für WordPress (Upload-Grösse etc.)
cat > "$WP_DIR/.user.ini" << EOF
upload_max_filesize = 64M
post_max_size = 64M
max_execution_time = 300
memory_limit = 256M
EOF

# PHP-FPM Config aktivieren
a2enconf php8.3-fpm
systemctl restart php8.3-fpm

# ------------------------------------------------------------
# SCHRITT 9: phpMyAdmin konfigurieren
# ------------------------------------------------------------
echo ""
echo ">>> [9/13] phpMyAdmin konfigurieren..."

cat > /etc/apache2/conf-available/phpmyadmin.conf << EOF
Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php
    AllowOverride All
    Require all granted
</Directory>
EOF

a2enconf phpmyadmin.conf

# ------------------------------------------------------------
# SCHRITT 10: SFTP-User anlegen
# ------------------------------------------------------------
echo ""
echo ">>> [10/13] SFTP-User anlegen..."

useradd -m -s /usr/sbin/nologin sftpuser

# Chroot-Verzeichnis muss root gehören
chown root:root /var/www

# SFTP-Konfiguration in sshd
cat > /etc/ssh/sshd_config.d/sftp-wordpress.conf << EOF
Match User sftpuser
    ChrootDirectory /var/www
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no
EOF

systemctl restart sshd

# ------------------------------------------------------------
# SCHRITT 11: WP-CLI installieren
# ------------------------------------------------------------
echo ""
echo ">>> [11/13] WP-CLI installieren..."

curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

echo ">>> WP-CLI Version: $(wp --info --allow-root 2>/dev/null | head -1 || echo 'installiert')"

# ------------------------------------------------------------
# SCHRITT 12: Berechtigungen setzen
# ------------------------------------------------------------
echo ""
echo ">>> [12/13] Berechtigungen setzen..."

chown -R www-data:www-data "$WP_DIR"
find "$WP_DIR" -type d -exec chmod 755 {} \;
find "$WP_DIR" -type f -exec chmod 644 {} \;

# Apache neu starten
systemctl restart apache2

# ------------------------------------------------------------
# SCHRITT 13: Backup-Script + CRON-Job einrichten
# ------------------------------------------------------------
echo ""
echo ">>> [13/13] Backup-Script und CRON-Job einrichten..."

mkdir -p /var/backups/wordpress

cat > /usr/local/bin/wp-backup.sh << 'BACKUP'
#!/bin/bash
# WordPress Backup Script – Files + DB, GPG-verschlüsselt
# Logfile: /var/log/wp-backup.log

set -euo pipefail

BACKUP_DIR="/var/backups/wordpress"
LOG_FILE="/var/log/wp-backup.log"
WP_DIR="/var/www/html"
DB_NAME="wordpress"
DB_USER="wpuser"
DB_PASS="SicheresPasswort123!"
GPG_RECIPIENT="backup@wordpress-server.dynv6.net"
RETENTION_DAYS=7
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/wp-backup-$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

log "=== Backup gestartet ==="

# DB-Dump
log "Datenbank-Dump erstellen..."
mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > /tmp/wp-db-backup.sql

# Files + DB zusammenpacken
log "Archiv erstellen..."
tar -czf "$BACKUP_FILE" -C /var/www html /tmp/wp-db-backup.sql
rm -f /tmp/wp-db-backup.sql

# GPG-Verschlüsselung (falls GPG-Key vorhanden)
if gpg --list-keys "$GPG_RECIPIENT" &>/dev/null; then
  log "GPG-Verschlüsselung..."
  gpg --batch --yes --encrypt --recipient "$GPG_RECIPIENT" \
      --output "${BACKUP_FILE}.gpg" "$BACKUP_FILE"
  rm -f "$BACKUP_FILE"
  log "Backup verschlüsselt: ${BACKUP_FILE}.gpg"
else
  log "HINWEIS: Kein GPG-Key für $GPG_RECIPIENT – Backup unverschlüsselt gespeichert."
fi

# Alte Backups löschen (Aufbewahrungsrichtlinie: 7 Tage)
log "Alte Backups aufräumen (älter als ${RETENTION_DAYS} Tage)..."
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete
find "$BACKUP_DIR" -name "*.gpg"   -mtime +$RETENTION_DAYS -delete

log "=== Backup abgeschlossen ==="
BACKUP

chmod 700 /usr/local/bin/wp-backup.sh

# CRON-Job: täglich um 02:00 Uhr
cat > /etc/cron.d/wp-backup << EOF
# WordPress Backup täglich um 02:00 Uhr
0 2 * * * root /usr/local/bin/wp-backup.sh
EOF

# ------------------------------------------------------------
# FERTIG
# ------------------------------------------------------------
echo ""
echo "================================================"
echo " ✅ WordPress Setup abgeschlossen!"
echo "================================================"
echo ""
echo " WordPress erreichbar unter:"
echo "   http://$DOMAIN"
echo ""
echo " phpMyAdmin:"
echo "   http://$DOMAIN/phpmyadmin"
echo ""
echo " MySQL Zugangsdaten:"
echo "   Datenbank: $DB_NAME"
echo "   Benutzer:  $DB_USER"
echo "   Passwort:  $DB_PASSWORD"
echo ""
echo " Backup:"
echo "   Script:  /usr/local/bin/wp-backup.sh"
echo "   CRON:    täglich 02:00 Uhr"
echo "   Ordner:  /var/backups/wordpress"
echo "   Log:     /var/log/wp-backup.log"
echo "================================================"

# Dieses Skript / Diese Befehle wurde / wurden teilweise durch KI erstellt / korrigiert.
