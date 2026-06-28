# 01 Projektplan
#### Migrationsprojekt
#### Modul 158

## Ubersicht
Das Ziel dieses Projektes ist die Migration einer bestehenden WordPress-Applikation auf eine AWS EC2 Instanz. Die Applikation war ursprunglich unter der Adresse `m158.geekz.ch` erreichbar und wurde auf eine neue Umgebung unter `wordpress-server.dynv6.net` ubertragen. Als Basis diente ein bestehendes WordPress-Backup, welches alle Dateien sowie einen SQL-Dump der Datenbank enthielt.

## Aufgaben
Das Projekt wurde in mehrere Tasks unterteilt, welche schrittweise abgearbeitet wurden. Dazu gehorte das Einrichten der DNS-Konfiguration, des Webservers, der Datenbankumgebung, von PHP sowie weiterer Dienste wie phpMyAdmin, SFTP und einem automatisierten Backup. Abgeschlossen wurde das Projekt mit Testing, Monitoring und der Einrichtung einer Deployment-Pipeline.

---

# 02 Architektur & System
#### Migrationsprojekt
#### Modul 158

## Umgebung
Als Arbeitsumgebung wurde AWS verwendet. Dateien wurden uber "Aktionen -> Datei hochladen" in der Konsole in AWS hochgeladen. Alle AWS CLI Befehle wurden in dieser Konsole ausgefuhrt.

## S3 Bucket
Es wurde ein S3 Bucket mit dem Namen `wordpress-backup-bsfh` erstellt. Das WordPress-Backup `2025-03-11_09-23-30_F5CZ3MQX01.zip` wurde aus CloudShell in den Bucket hochgeladen und dabei in `wordpress.zip` umbenannt.

## EC2 Instanz
Es wurde eine EC2 Instanz mit Ubuntu 24.04 in der Region `us-east-1` erstellt. Als Instance-Typ wurde `t3.micro` gewahlt. Die Instanz wurde mit dem Key Pair `wordpress-key` gestartet. Nach dem Start war WordPress uber die offentliche IP-Adresse der Instanz erreichbar.

---

# 03 Umgebung
#### Migrationsprojekt
#### Modul 158

## Webserver
Als Webserver wurde Apache2 eingesetzt. Es wurde eine VirtualHost-Konfigurationsdatei `wordpress.conf` in `/etc/apache2/sites-available/` erstellt, mit `ServerName wordpress-server.dynv6.net`, DocumentRoot `/var/www/html` und `AllowOverride All`, damit die `.htaccess` von WordPress greift. Das Apache-Modul `mod_rewrite` wurde aktiviert, die Default-Site `000-default.conf` deaktiviert und Apache neu gestartet.

## Security Group
Eine Security Group fungiert als Firewall fur die EC2 Instanz und steuert, welche Ports offen oder geschlossen sind. In diesem Projekt wurden Port 80 (HTTP) sowie Port 443 (HTTPS) geoffnet, damit WordPress im Browser erreichbar ist. Port 22 (SSH) wurde fur Verwaltungszwecke ebenfalls geoffnet.

---

# 04 DNS
#### Migrationsprojekt
#### Modul 158

## dynv6
Um die EC2 Instanz unter einer festen Domain zu erreichen, wurde der Dienst dynv6 verwendet. Dort wurde die Subdomain `wordpress-server.dynv6.net` eingerichtet. Der EC2 Instanz wurde eine Elastic IP zugewiesen, damit die offentliche IP-Adresse auch nach einem Neustart der Instanz unverandert bleibt. Diese IP-Adresse wurde dann im dynv6-Dashboard als A-Record hinterlegt. So ist die WordPress-Applikation dauerhaft unter `http://wordpress-server.dynv6.net` erreichbar.

---

# 06 PHP
#### Migrationsprojekt
#### Modul 158

## PHP und PHP-FPM
PHP ist eine serverseitige Programmiersprache, auf der WordPress vollstandig aufbaut. PHP-FPM (FastCGI Process Manager) ist ein eigenstandiger Dienst, der PHP-Dateien ausfuhrt und uber einen Socket mit Apache kommuniziert. Dies ist die moderne Alternative zu `mod_php`, da PHP-FPM stabiler und ressourcenschonender arbeitet.

## Installation
PHP 8.3 wurde zusammen mit PHP-FPM und allen fur WordPress benotigten Modulen installiert. Dazu gehorenunter anderem `php8.3-mysql`, `php8.3-curl`, `php8.3-gd`, `php8.3-mbstring`, `php8.3-xml` und `php8.3-zip`. Der Apache-VirtualHost wurde so konfiguriert, dass `.php`-Anfragen uber den FastCGI-Handler an PHP-FPM weitergeleitet werden. Zusatzlich wurde eine `.user.ini`-Datei in `/var/www/html` erstellt, welche Upload-Limits und Speichergrenzen definiert.

---

# 07 Datenbank
#### Migrationsprojekt
#### Modul 158

## MySQL
Als Datenbank wurde MySQL auf der EC2 Instanz installiert. Die bestehende WordPress-Datenbank wurde aus dem Backup (`wp_m158_db.sql`) wiederhergestellt. Dazu wurde zunachst eine neue Datenbank mit dem Namen `wordpress` angelegt. Anschliessend wurde ein Datenbankbenutzer `wpuser` erstellt, dem ausschliesslich Rechte auf diese eine Datenbank und nur von `localhost` aus gewahrte wurden. Der SQL-Dump wurde importiert und die Zugangsdaten in der `wp-config.php` eingetragen. Die anonymen Standardbenutzer sowie die Test-Datenbank wurden zur Hartung entfernt.

---

# 08 phpMyAdmin
#### Migrationsprojekt
#### Modul 158

## Installation und Konfiguration
phpMyAdmin wurde als grafisches Verwaltungswerkzeug fur die MySQL-Datenbank installiert. Es ist uber den Pfad `/phpmyadmin` auf dem Server erreichbar. Dazu wurde ein Apache-Alias eingerichtet, der Anfragen an `/phpmyadmin` auf das Verzeichnis `/usr/share/phpmyadmin` weiterleitet. phpMyAdmin verwendet die Cookie-Authentifizierung, was bedeutet, dass sich jeder Benutzer mit seinen MySQL-Zugangsdaten anmelden muss. phpMyAdmin benotigt keine eigene Datenbank fur den Grundbetrieb, kann jedoch optional eine Konfigurationsdatenbank anlegen, um erweiterte Funktionen wie gespeicherte Abfragen zu nutzen.

---

# 09 SFTP / FTPS
#### Migrationsprojekt
#### Modul 158

## SFTP-Zugang
Fur den Dateizugriff auf den Server wurde ein SFTP-Benutzer `sftpuser` eingerichtet. Dieser Benutzer kann sich ausschliesslich per SFTP verbinden und wird durch eine Chroot-Konfiguration auf das Verzeichnis `/var/www` eingeschrankt. Eine normale SSH-Anmeldung ist fur diesen Benutzer nicht moglich, da die Shell auf `/usr/sbin/nologin` gesetzt ist. Die entsprechende Konfiguration wurde in `/etc/ssh/sshd_config.d/sftp-wordpress.conf` hinterlegt.

---

# 10 WordPress Migration
#### Migrationsprojekt
#### Modul 158

## Wiederherstellung
Die WordPress-Migration erfolgte durch das Einspielen eines bestehenden Backups auf die EC2 Instanz. Das Backup enthielt alle WordPress-Dateien sowie einen SQL-Dump der Datenbank. Die Dateien wurden nach `/var/www/html` kopiert und die Datenbank importiert. Da WordPress die eigene URL in der Datenbank speichert und alle Anfragen dorthin weiterleitet, mussten nach der Migration die Felder `siteurl` und `home` in der Tabelle `VtgnJGv_options` auf die neue Adresse `http://wordpress-server.dynv6.net` aktualisiert werden. Dies war notig, da die alte URL `m158.geekz.ch` noch in der Datenbank hinterlegt war und alle Besucher dorthin weiterleitete.

## wp-config.php
Damit die URL-Konfiguration auch nach einem Neustart der Instanz bestehen bleibt, wurden die Konstanten `WP_HOME` und `WP_SITEURL` direkt in der `wp-config.php` definiert. Diese Einstellung hat Vorrang vor den Datenbankeinträgen und verhindert, dass nach einem Neustart erneut die alte URL eingetragen wird.

---

# 11 WP-CLI
#### Migrationsprojekt
#### Modul 158

## Installation
WP-CLI ist ein Kommandozeilenwerkzeug zur Verwaltung von WordPress. Es ermoglicht es, Benutzer, Plugins, Themes und Einstellungen direkt uber das Terminal zu verwalten, ohne den Browser-basierten Admin-Bereich zu verwenden. WP-CLI wurde heruntergeladen, ausfuhrbar gemacht und unter `/usr/local/bin/wp` abgelegt, damit es systemweit verfugbar ist. Im Projekt wurde WP-CLI unter anderem genutzt, um das Admin-Passwort zuruckzusetzen und den Zugang zum WordPress-Adminbereich wiederherzustellen.

---

# 12 Backup
#### Migrationsprojekt
#### Modul 158

## Backup-Script
Ein automatisiertes Backup-Script wurde unter `/usr/local/bin/wp-backup.sh` eingerichtet. Das Script erstellt taglich um 02:00 Uhr ein vollstandiges Backup, bestehend aus allen WordPress-Dateien sowie einem Datenbank-Dump. Beide werden in einem komprimierten Archiv zusammengefasst. Sofern ein GPG-Schlussel fur den Empfanger `backup@wordpress-server.dynv6.net` vorhanden ist, wird das Archiv verschlusselt gespeichert. Andernfalls wird das Backup unverschlusselt abgelegt und eine entsprechende Meldung ins Logfile geschrieben. Backups, die alter als sieben Tage sind, werden automatisch geloscht. Alle Aktionen werden in `/var/log/wp-backup.log` protokolliert.

## CRON-Job
Der CRON-Job wurde in `/etc/cron.d/wp-backup` hinterlegt und fuhrt das Script automatisch taglich aus.

---

# 13 Testing
#### Migrationsprojekt
#### Modul 158

## WordPress Site Health
Der Gesundheitsstatus der WordPress-Installation wurde uber `wp-admin/site-health.php` uberpruft. Initial wurden dabei drei kritische Probleme gemeldet. Diese betrafen fehlende Schreibrechte fur WordPress im Dateisystem sowie veraltete Themes. Die Schreibrechte wurden durch Anpassen der Verzeichnisberechtigungen mit `chown` und `chmod` behoben. Die Themes wurden anschliessend uber das WordPress-Dashboard aktualisiert. Nach diesen Korrekturen zeigte Site Health den Status "Gut" an.

## Browser-Konsole
Die Website wurde im Browser geoffnet und die Entwicklerkonsole (F12) auf Fehlermeldungen uberpruft. Es wurden keine kritischen roten Fehler festgestellt. Lediglich eine informative Meldung von jQuery Migrate war sichtbar, welche bei WordPress ublich ist und keine Funktionsbeeintrachtigungdarstellt.

---

# 14 Monitoring
#### Migrationsprojekt
#### Modul 158

## Zweite EC2 Instanz
Fur das Monitoring wurde eine zweite EC2 Instanz eingerichtet. Diese Instanz uberpruft in einem regelmasigen Intervall, ob die WordPress-Hauptinstanz uber HTTP erreichbar ist. Die Konfiguration der Monitoring-Instanz erfolgte uber ein Cloud-Init File, welches beim Start der Instanz automatisch ausgefuhrt wurde. Da die Instanz jedoch bereits einmal ohne das File gestartet worden war, wurde das Setup-Script nachtraglich manuell ausgefuhrt.

## Monitoring-Script
Das Script `/usr/local/bin/wp-monitor.sh` fuhrt alle funf Minuten einen HTTP-Request auf `http://wordpress-server.dynv6.net` aus. Weicht der zuruckgegebene HTTP-Statuscode von den erwarteten Werten 200, 301 oder 302 ab, wird eine Benachrichtigung uber den Dienst `ntfy.sh` gesendet. Um Benachrichtigungs-Spam zu vermeiden, wird nur bei einem tatsachlichen Statuswechsel, also von "erreichbar" zu "nicht erreichbar" oder umgekehrt, eine Meldung ausgelost. Alle Checks werden in `/var/log/wp-monitor.log` protokolliert. Beim ersten Check nach der Einrichtung lieferte die Hauptinstanz den Statuscode 200, was eine erfolgreiche Einrichtung des Monitorings bestatigt.

---

# 15 Deployment
#### Migrationsprojekt
#### Modul 158

## GitLab CI/CD
Die Deployment-Pipeline wurde mit GitLab CI/CD umgesetzt. Ziel ist es, Anderungen am Code automatisch auf den Server zu ubertragen, sobald ein Commit auf den `staging`-Branch gepusht wird. Die Pipeline verbindet sich per SSH mit der EC2 Instanz und zieht dort die aktuellen Dateien vom Repository. So kann neuer Code ohne manuelle Schritte auf dem Server bereitgestellt werden.
