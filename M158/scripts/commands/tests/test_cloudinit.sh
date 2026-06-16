#cloud-config
# ============================================================
# Cloud-Init für WordPress-Server (M158)
# Ubuntu 24.04 LTS auf AWS EC2
# Domain: wordpress-server.dynv6.net
# ============================================================

# ------------------------------------------------------------
# SYSTEM-UPDATE & PAKETE
# ------------------------------------------------------------
package_update: true
package_upgrade: true

packages:
  # Webserver
  - apache2
  # PHP mit FPM (statt mod_php) + alle WP-Module
  - php8.3-fpm
  - php8.3-mysql
  - php8.3-curl
  - php8.3-gd
  - php8.3-mbstring
  - php8.3-xml
  - php8.3-zip
  - php8.3-intl
  - php8.3-bcmath
  - php8.3-imagick
  # Datenbank
  - mysql-server
  # WP-CLI Abhängigkeit
  - curl
  - wget
  # Backup & Verschlüsselung (Task 09)
  - gnupg
  # SFTP (Task 07) – läuft über openssh-server (meist vorinstalliert)
  - openssh-server
  # phpMyAdmin (Task 06)
  - phpmyadmin
  # AWS CLI
  - awscli
  # Hilfsprogramme
  - unzip
  - git

# ------------------------------------------------------------
# DATEIEN SCHREIBEN
# ------------------------------------------------------------
write_files:

  # --- Apache VirtualHost (Task 03) ---
  - path: /etc/apache2/sites-available/wordpress.conf
    content: |
      <VirtualHost *:80>
          ServerName wordpress-server.dynv6.net
          ServerAlias www.wordpress-server.dynv6.net
          DocumentRoot /var/www/html
          DirectoryIndex index.php index.html

          <Directory /var/www/html>
              Options FollowSymLinks
              AllowOverride All
              Require all granted
          </Directory>

          # PHP-FPM (Task 04)
          <FilesMatch \.php$>
              SetHandler "proxy:unix:/run/php/php8.3-fpm.sock|fcgi://localhost"
          </FilesMatch>

          ErrorLog ${APACHE_LOG_DIR}/wordpress-error.log
          CustomLog ${APACHE_LOG_DIR}/wordpress-access.log combined
      </VirtualHost>
    owner: root:root
    permissions: '0644'

  # --- PHP user.ini für WordPress (Task 04) ---
  - path: /var/www/html/.user.ini
    content: |
      upload_max_filesize = 64M
      post_max_size = 64M
      max_execution_time = 300
      memory_limit = 256M
    owner: www-data:www-data
    permissions: '0644'

  # --- PHP-FPM Pool-Konfiguration (Task 04) ---
  - path: /etc/php/8.3/fpm/pool.d/wordpress.conf
    content: |
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
    owner: root:root
    permissions: '0644'

  # --- phpMyAdmin Apache-Config (Task 06) ---
  - path: /etc/apache2/conf-available/phpmyadmin.conf
    content: |
      Alias /phpmyadmin /usr/share/phpmyadmin
      <Directory /usr/share/phpmyadmin>
          Options SymLinksIfOwnerMatch
          DirectoryIndex index.php
          AllowOverride All
          Require all granted
      </Directory>
    owner: root:root
    permissions: '0644'

  # --- SFTP-User chroot Konfiguration in sshd_config (Task 07) ---
  # (wird per runcmd aktiviert)
  - path: /etc/ssh/sshd_config.d/sftp-wordpress.conf
    content: |
      Match User sftpuser
          ChrootDirectory /var/www
          ForceCommand internal-sftp
          AllowTcpForwarding no
          X11Forwarding no
    owner: root:root
    permissions: '0644'

  # --- Backup-Script mit GPG-Verschlüsselung (Task 09) ---
  - path: /usr/local/bin/wp-backup.sh
    content: |
      #!/bin/bash
      # WordPress Backup Script – Files + DB, GPG-verschlüsselt
      # Logfile: /var/log/wp-backup.log
      
      set -euo pipefail
      
      BACKUP_DIR="/var/backups/wordpress"
      LOG_FILE="/var/log/wp-backup.log"
      WP_DIR="/var/www/html"
      DB_NAME="wordpress"
      DB_USER="wpuser"
      DB_PASS="CHANGE_ME_DB_PASSWORD"
      GPG_RECIPIENT="backup@wordpress-server.dynv6.net"
      RETENTION_DAYS=7
      DATE=$(date +%Y-%m-%d_%H-%M-%S)
      BACKUP_FILE="$BACKUP_DIR/wp-backup-$DATE.tar.gz"
      
      mkdir -p "$BACKUP_DIR"
      
      log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }
      
      log "=== Backup gestartet ==="
      
      # DB-Dump
      log "Datenbank-Dump..."
      mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > /tmp/wp-db-backup.sql
      
      # Files + DB zusammenpacken
      log "Archiv erstellen..."
      tar -czf "$BACKUP_FILE" -C /var/www html /tmp/wp-db-backup.sql
      rm -f /tmp/wp-db-backup.sql
      
      # GPG-Verschlüsselung
      log "Verschlüsseln..."
      gpg --batch --yes --encrypt --recipient "$GPG_RECIPIENT" \
          --output "$BACKUP_FILE.gpg" "$BACKUP_FILE"
      rm -f "$BACKUP_FILE"
      
      # Alte Backups löschen (Aufbewahrungsrichtlinie: 7 Tage)
      log "Alte Backups aufräumen (älter als ${RETENTION_DAYS} Tage)..."
      find "$BACKUP_DIR" -name "*.gpg" -mtime +$RETENTION_DAYS -delete
      
      log "=== Backup abgeschlossen: ${BACKUP_FILE}.gpg ==="
    owner: root:root
    permissions: '0700'

  # --- CRON-Job für Backup (Task 09) ---
  - path: /etc/cron.d/wp-backup
    content: |
      # WordPress Backup täglich um 02:00 Uhr
      0 2 * * * root /usr/local/bin/wp-backup.sh
    owner: root:root
    permissions: '0644'

# ------------------------------------------------------------
# RUNCMD – Konfiguration zur Laufzeit
# ------------------------------------------------------------
runcmd:

  # System-Log für dieses Script
  - echo "=== cloud-init runcmd gestartet ===" >> /var/log/wordpress-setup.log

  # --- Apache Module aktivieren (Task 03 & 04) ---
  - a2enmod rewrite
  - a2enmod proxy_fcgi
  - a2enmod setenvif
  - a2enmod headers
  - a2enmod ssl
  # Default-Site deaktivieren, WordPress-Site aktivieren
  - a2dissite 000-default.conf
  - a2ensite wordpress.conf
  # phpMyAdmin-Config aktivieren (Task 06)
  - a2enconf phpmyadmin.conf

  # --- PHP-FPM aktivieren (Task 04) ---
  - a2enconf php8.3-fpm
  - systemctl enable php8.3-fpm
  - systemctl start php8.3-fpm

  # --- MySQL absichern & Datenbank anlegen (Task 05) ---
  - |
    mysql -e "
      CREATE DATABASE IF NOT EXISTS wordpress CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
      CREATE USER IF NOT EXISTS 'wpuser'@'localhost' IDENTIFIED BY 'CHANGE_ME_DB_PASSWORD';
      GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
      DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
      DELETE FROM mysql.user WHERE User='';
      DROP DATABASE IF EXISTS test;
      FLUSH PRIVILEGES;
    "

  # --- WordPress herunterladen & einrichten (Task 08) ---
  # Option A: Von S3 (Backup wiederherstellen)
  # Auskommentieren falls Backup in S3 vorhanden:
  # - aws s3 cp s3://wordpress-backup-bsfh/wordpress.zip /tmp/wordpress.zip
  # - unzip -o /tmp/wordpress.zip -d /tmp/wp-extract
  # - rsync -av /tmp/wp-extract/ /var/www/html/
  
  # Option B: Frische WordPress-Installation
  - wget -q https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz
  - tar -xzf /tmp/wordpress.tar.gz -C /tmp/
  - rsync -av --exclude=wp-config.php /tmp/wordpress/ /var/www/html/
  - |
    cat > /var/www/html/wp-config.php << 'WPCONFIG'
    <?php
    define('DB_NAME',     'wordpress');
    define('DB_USER',     'wpuser');
    define('DB_PASSWORD', 'CHANGE_ME_DB_PASSWORD');
    define('DB_HOST',     'localhost');
    define('DB_CHARSET',  'utf8mb4');
    define('DB_COLLATE',  '');
    define('WP_HOME',    'http://wordpress-server.dynv6.net');
    define('WP_SITEURL', 'http://wordpress-server.dynv6.net');
    // Sicherheits-Keys (https://api.wordpress.org/secret-key/1.1/salt/ ersetzen!)
    define('AUTH_KEY',         'CHANGE_ME');
    define('SECURE_AUTH_KEY',  'CHANGE_ME');
    define('LOGGED_IN_KEY',    'CHANGE_ME');
    define('NONCE_KEY',        'CHANGE_ME');
    define('AUTH_SALT',        'CHANGE_ME');
    define('SECURE_AUTH_SALT', 'CHANGE_ME');
    define('LOGGED_IN_SALT',   'CHANGE_ME');
    define('NONCE_SALT',       'CHANGE_ME');
    $table_prefix = 'wp_';
    define('WP_DEBUG', false);
    if (!defined('ABSPATH')) define('ABSPATH', __DIR__ . '/');
    require_once ABSPATH . 'wp-settings.php';
    WPCONFIG

  # --- WP-CLI installieren (Task 08) ---
  - curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  - chmod +x wp-cli.phar
  - mv wp-cli.phar /usr/local/bin/wp

  # --- Berechtigungen setzen ---
  - chown -R www-data:www-data /var/www/html
  - find /var/www/html -type d -exec chmod 755 {} \;
  - find /var/www/html -type f -exec chmod 644 {} \;

  # --- SFTP-User anlegen (Task 07) ---
  - useradd -m -s /usr/sbin/nologin sftpuser
  - mkdir -p /var/www/html
  - chown root:root /var/www
  - systemctl restart sshd

  # --- Apache neu starten ---
  - systemctl enable apache2
  - systemctl restart apache2

  # --- phpMyAdmin Datenbank-Konfiguration (Task 06) ---
  # phpMyAdmin legt seine Konfig-DB automatisch an beim ersten Start

  # --- Abschluss ---
  - echo "=== Setup abgeschlossen: $(date) ===" >> /var/log/wordpress-setup.log
  - echo "WordPress: http://wordpress-server.dynv6.net" >> /var/log/wordpress-setup.log

# Neustart nach Setup
power_state:
  mode: reboot
  message: "Cloud-init Setup abgeschlossen, Neustart..."
  timeout: 30
  condition: true