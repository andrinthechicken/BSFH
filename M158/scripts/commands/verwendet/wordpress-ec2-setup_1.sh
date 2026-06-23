#!/bin/bash
# ============================================================
#
# Schritte:
#   1. Apache, PHP, MySQL installieren
#   2. ZIP von S3 herunterladen und entpacken
#   3. WordPress-Dateien nach /var/www/html kopieren
#   4. MySQL-Datenbank anlegen und SQL-Dump importieren
#   5. wp-config.php mit neuen DB-Zugangsdaten aktualisieren
#   6. Berechtigungen setzen
#   7. Apache konfigurieren
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

# ------------------------------------------------------------

echo "================================================"
echo " WordPress EC2 Setup startet..."
echo "================================================"

# ------------------------------------------------------------
# SCHRITT 1: System aktualisieren
# ------------------------------------------------------------
echo ""
echo ">>> [1/7] System aktualisieren..."
apt-get update -y
apt-get upgrade -y

# ------------------------------------------------------------
# SCHRITT 2: Apache, PHP und MySQL installieren
# ------------------------------------------------------------
echo ""
echo ">>> [2/7] Apache, PHP, MySQL installieren..."
apt-get install -y \
  apache2 \
  mysql-server \
  php \
  php-mysql \
  php-curl \
  php-gd \
  php-mbstring \
  php-xml \
  php-xmlrpc \
  php-zip \
  php-intl \
  unzip \
  awscli

systemctl start apache2
systemctl enable apache2
systemctl start mysql
systemctl enable mysql

# ------------------------------------------------------------
# SCHRITT 3: ZIP von S3 herunterladen und entpacken
# ------------------------------------------------------------
echo ""
echo ">>> [3/7] ZIP von S3 herunterladen..."
aws s3 cp "s3://$S3_BUCKET/$S3_KEY" /tmp/wordpress.zip

echo ">>> ZIP entpacken..."
mkdir -p /tmp/wp-extract
unzip -o /tmp/wordpress.zip -d /tmp/wp-extract

# WordPress-Dateien finden
WP_SOURCE=$(find /tmp/wp-extract -name "wp-config.php" -maxdepth 3 | head -1 | xargs dirname)
echo ">>> WordPress-Dateien gefunden in: $WP_SOURCE"

# ------------------------------------------------------------
# SCHRITT 4: WordPress-Dateien kopieren
# ------------------------------------------------------------
echo ""
echo ">>> [4/7] WordPress-Dateien nach $WP_DIR kopieren..."
rm -f "$WP_DIR/index.html"
cp -r "$WP_SOURCE"/. "$WP_DIR/"

# ------------------------------------------------------------
# SCHRITT 5: MySQL Datenbank anlegen und SQL importieren
# ------------------------------------------------------------
echo ""
echo ">>> [5/7] Datenbank anlegen und SQL importieren..."

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_USER'@'localhost';
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
echo ">>> [6/7] wp-config.php aktualisieren..."

WP_CONFIG="$WP_DIR/wp-config.php"

sed -i "s/define( *'DB_NAME', *'[^']*' *)/define('DB_NAME', '$DB_NAME')/" "$WP_CONFIG"
sed -i "s/define( *'DB_USER', *'[^']*' *)/define('DB_USER', '$DB_USER')/" "$WP_CONFIG"
sed -i "s/define( *'DB_PASSWORD', *'[^']*' *)/define('DB_PASSWORD', '$DB_PASSWORD')/" "$WP_CONFIG"
sed -i "s/define( *'DB_HOST', *'[^']*' *)/define('DB_HOST', '$DB_HOST')/" "$WP_CONFIG"

# Öffentliche IP ermitteln und WordPress URL setzen
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo ">>> Öffentliche IP: $PUBLIC_IP"

mysql -u root "$DB_NAME" << EOF
UPDATE wp_options SET option_value = 'http://$PUBLIC_IP' WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value = 'http://$PUBLIC_IP' WHERE option_name = 'home';
EOF

echo ">>> WordPress URL gesetzt auf: http://$PUBLIC_IP"

# ------------------------------------------------------------
# SCHRITT 7: Berechtigungen und Apache konfigurieren
# ------------------------------------------------------------
echo ""
echo ">>> [7/7] Berechtigungen setzen und Apache konfigurieren..."

chown -R www-data:www-data "$WP_DIR"
find "$WP_DIR" -type d -exec chmod 755 {} \;
find "$WP_DIR" -type f -exec chmod 644 {} \;

a2enmod rewrite

cat > /etc/apache2/sites-available/wordpress.conf << EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot $WP_DIR

    <Directory $WP_DIR>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/wordpress-error.log
    CustomLog \${APACHE_LOG_DIR}/wordpress-access.log combined
</VirtualHost>
EOF

a2dissite 000-default.conf
a2ensite wordpress.conf
systemctl restart apache2

# ------------------------------------------------------------
# FERTIG
# ------------------------------------------------------------
echo ""
echo "================================================"
echo " ✅ WordPress Setup abgeschlossen!"
echo "================================================"
echo ""
echo " WordPress erreichbar unter:"
echo "   http://$PUBLIC_IP"
echo ""
echo ""
echo " MySQL Zugangsdaten:"
echo "   Datenbank: $DB_NAME"
echo "   Benutzer:  $DB_USER"
echo "   Passwort:  $DB_PASSWORD"
echo "================================================"

# Dieses Skript / Diese Befehle wurde / wurden teilweise durch KI erstellt / korrigiert.