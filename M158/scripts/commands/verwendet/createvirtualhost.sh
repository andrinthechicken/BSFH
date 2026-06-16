# VirtualHost auf Port 80 (HTTP) für alle Netzwerkinterfaces
<VirtualHost *:80>

    # E-Mail des Administrators
    ServerAdmin webmaster@localhost

    # Domain unter der WordPress erreichbar ist
    ServerName wordpress-server.dynv6.net

    # Ordner in dem WordPress liegt
    DocumentRoot /var/www/html

    # Einstellungen für das WordPress-Verzeichnis
    <Directory /var/www/html>

        # FollowSymLinks ist nötig damit mod_rewrite funktioniert
        # Indexes entfernt – verhindert dass Verzeichnisinhalte angezeigt werden
        Options FollowSymLinks

        # Erlaubt WordPress die .htaccess zu nutzen
        AllowOverride All

        # Zugriff für alle erlauben
        Require all granted

    </Directory>

    # Fehler-Log
    ErrorLog ${APACHE_LOG_DIR}/wordpress-error.log

    # Zugriffs-Log
    CustomLog ${APACHE_LOG_DIR}/wordpress-access.log combined

</VirtualHost>
EOF