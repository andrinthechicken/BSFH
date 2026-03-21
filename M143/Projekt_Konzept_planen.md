# Projekt: Konzept planen
### Modul 143

Es folgt die Dokumentation zu folgenden Auftrag: 
https://gitlab.com/ch-tbz-it/Stud/m143/-/blob/main/02-Datensicherungskonzept/03-Planung/Konzept_planen_v2.3.pdf?ref_type=heads

*Server 1 detailierter*
## Konfiguration Server 1 (MA-Daten)

### Backup-Art
Das Backup der Daten des Servers 1 wird zur besseren Überwachung respektive Kontrolle on-premise durchgeführt werden. Hierfür wird ein NAS zum Einsatz kommen. Da bisher keine Backupinfrastruktur vorhanden war, ist eine Migration nicht nötig. Die wichtigsten Daten aus diesem Datenpool werden zusätzlich regelmässig auf Tape geschrieben und offsite gelagert. Diese Tapes werden nach Ablauf der Aufbewarungszeit fachgerecht entsorgt. Die Aufbewarungszeit wird noch durch den Kunden definiert.

### Datenmenge
Zum Zeitpunkt des Go Live wird die Datenmenge auf dem Server 1 verraussichtlich rund 25.5 TB (Es wurde hier auch die Dauer bis zur Umsetzung des Projektes mit einberechnet) betragen. Pro Jahr wird ein Zuwachs von rund 1 TB erwartet. Hier sind mögliche neue Mitarbeiter bereits eingerechnet. Aufgrund der Stabilität der Firma ist kein Ein- oder Ausbruch des Volumens zu erwarten. Die maximale Speicheranforderung an das NAS durch die MA Daten liegt also nach 5 Jahren bei ungefähr 100 TB. Es wurde hierbei die steigende Menge an Daten der MA beachtet. Wie es zu dieser Zahl kommt, ist unter Backschema dargelegt.

### Backupschema
Das Backup auf das Backup-NAS wird jede Nacht durch die Applikation Veeam gegen 02:00 Uhr durchgeführt werden. Es ist mit keinen Unterbrüchen im Netzwerkbetrieb zu rechnen. Die Daten werden auf das NAS gespielt. Es wird ein inkrementelles Backupschema verwendet. Das Full Backup findet hierbei jeweils an jedem Sonntag statt. Das NAS verwendet das Konzept RAID 6. Am ersten Sonntag des Monats werden die essentiellen Daten zusätzlich um 19 Uhr auf Tape (LTO) gespielt. Welche Daten auf Tape gespielt werden sollen, wird noch durch den Kunden definiert.

### Infrastruktur
Es wird, nebst dem grundlegenden Server 1, mit einem leistungsfähigen NAS sowie mit LTO gearbeitet werden. Die Bänder werden extern in einem vor höheren Mächten geschützten Tresor aufbewart werden. Ein Band kann ungefähr 45 TB und kosten ungefähr 150 CHF. Die Preise und Leitungen der Bänder können jedoch variieren. Beim Wahl des NAS fiel die Wahl auf eine Synology 12-bay DiskStation AMD Ryzen V1500B quad (DS2422+). Die Anschaffungskosten liegen bei ungefähr 2000 CHF. Die zusätzlichen Anschaffungkosten für die benötigen Disks liegen bei ungefähr 6000 CHF. Diese Kosten decken die physische Infrastrucktur für das gesamte Backupkonzept ab. Für die Bereiche Server 2 und Server 3 fallen lediglich die Kosten für die zu verwendeten LTO Bänder an. Die Gesamtkosten für jene werden jedoch aufgrund ihrer Unberechenbarkeit hier nicht dargelegt.

### Backupsoftware
Als Backupsoftware

## Konfiguration Server 2 (Administration)

### Backup-Art


### Datenmenge


### Backupschema


### Infrastruktur


### Backupsoftware

## Konfiguration Server 3 (Bestellungen / Aufträge)

### Backup-Art


### Datenmenge


### Backupschema


### Infrastruktur


### Backupsoftware

## Legende

### Reflexion
