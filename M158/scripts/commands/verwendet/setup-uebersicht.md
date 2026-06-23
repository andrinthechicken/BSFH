# Setup-Script Übersicht

## A) Was das Script automatisch erledigt

Beim ersten Start der EC2-Instanz wird das Script automatisch ausgeführt und übernimmt folgende Schritte:

Das System wird aktualisiert und alle benötigten Pakete werden installiert: Apache, PHP 8.3 mit FPM und allen WordPress-Modulen, MySQL, phpMyAdmin, WP-CLI sowie die benötigten Hilfsprogramme. Anschliessend wird das WordPress-Backup als ZIP-Datei aus dem S3-Bucket heruntergeladen, entpackt und die Dateien nach `/var/www/html` kopiert. Die MySQL-Datenbank wird angelegt, der SQL-Dump importiert und die Zugangsdaten in der `wp-config.php` eingetragen. Die WordPress-URL wird direkt auf `wordpress-server.dynv6.net` gesetzt.

Apache wird mit einem VirtualHost für die Domain konfiguriert, `mod_rewrite` aktiviert und PHP-FPM als Handler eingebunden. Der PHP-FPM Pool wird mit sinnvollen Limits für Upload-Grösse und Arbeitsspeicher eingerichtet. phpMyAdmin wird unter `/phpmyadmin` erreichbar gemacht. Ein SFTP-User `sftpuser` wird angelegt und auf das Verzeichnis `/var/www` eingeschränkt. Abschliessend wird ein Backup-Script eingerichtet, das täglich um 02:00 Uhr automatisch ausgeführt wird, Files und Datenbank sichert, GPG-verschlüsselt ablegt und Backups nach 7 Tagen löscht.

---

## B) Was noch von Hand gemacht werden muss

**dynv6 DNS-Eintrag aktualisieren**
Nach jedem Start der Instanz muss die aktuelle öffentliche IP-Adresse manuell im dynv6-Dashboard eingetragen werden, damit `wordpress-server.dynv6.net` auf die Instanz zeigt.

**SSL/HTTPS einrichten**
Das Zertifikat über Let's Encrypt kann erst nach dem Start konfiguriert werden, wenn der DNS-Eintrag korrekt gesetzt ist und die Domain erreichbar ist. Dazu muss Certbot manuell ausgeführt werden.

**SFTP-Passwort oder SSH-Key für sftpuser setzen**
Der SFTP-User wird zwar angelegt, erhält aber kein Passwort und keinen SSH-Key. Der Zugang muss nach dem Start manuell eingerichtet werden.

**GPG-Key für Backup-Verschlüsselung importieren**
Das Backup-Script ist auf GPG-Verschlüsselung ausgelegt, speichert aber unverschlüsselt, solange kein GPG-Key für `backup@wordpress-server.dynv6.net` auf dem Server vorhanden ist. Der Key muss manuell importiert werden.
