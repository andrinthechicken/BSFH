# Projekt: Konzept planen
### Modul 143

Es folgt die Dokumentation zu folgenden Auftrag: 
https://gitlab.com/ch-tbz-it/Stud/m143/-/blob/main/02-Datensicherungskonzept/03-Planung/Konzept_planen_v2.3.pdf?ref_type=heads  

Alle diese Angaben sind auf einen Betrieb von 5 Jahren ausgelegt. Eine Verlängerung des Betriebes ist aufgrund der verwendeten Infrastruktur jedoch problemlos möglich.

*Server 1 detailierter*
## Konfiguration Server 1 (MA-Daten)

### Backup-Art
Das Backup der Daten des Servers 1 wird zur besseren Überwachung respektive Kontrolle on-premise durchgeführt werden. Hierfür wird ein NAS zum Einsatz kommen. Da bisher keine Backupinfrastruktur vorhanden war, ist eine Migration nicht nötig. Die wichtigsten Daten aus diesem Datenpool werden zusätzlich regelmässig auf Tape geschrieben und offsite gelagert. Diese Tapes werden nach Ablauf der Aufbewahrungszeit fachgerecht entsorgt. Die Aufbewahrungszeit wird noch durch den Kunden definiert.

### Datenmenge
Zum Zeitpunkt des Go Live wird die Datenmenge auf dem Server 1 verraussichtlich rund 25.5 TB (Es wurde hier auch die Dauer bis zur Umsetzung des Projektes mit einberechnet) betragen. Pro Jahr wird ein Zuwachs von rund 1 TB erwartet. Hier sind mögliche neue Mitarbeiter bereits eingerechnet. Aufgrund der Stabilität der Firma ist kein Ein- oder Ausbruch des Volumens zu erwarten. Die maximale Speicheranforderung an das NAS durch die MA Daten liegt also nach 5 Jahren bei ungefähr 100 TB. Es wurde hierbei die steigende Menge an MA beachtet. Wie es zu dieser Zahl kommt, ist unter "Backupschema" dargelegt.

### Backupschema
Das Backup auf das Backup-NAS wird jede Nacht durch die Applikation Veeam gegen 02:00 Uhr durchgeführt werden. Es ist mit keinen Unterbrüchen im Netzwerkbetrieb zu rechnen. Die Daten des Servers 1 werden auf das NAS gespielt. Es wird ein inkrementelles Backupschema verwendet. Das Full Backup findet hierbei jeweils an jedem Sonntag statt. Das NAS verwendet das Konzept RAID 6. Am ersten Sonntag jedes Monats werden die essentiellen Daten zusätzlich um 19 Uhr auf Tape (LTO) gespielt. Welche Daten auf Tape gespielt werden sollen, wird noch durch den Kunden definiert. Die Daten werden auf dem NAS für jeweils 30 Tage gespeichert. Anschliessend werden sie gelöscht. Dadurch sind jegliche Daten für 30 Tage und die wichtigen Daten deutlich länger verfügbar. So kann sowohl Speicherplatz als auch Geld gespart werden.

### Infrastruktur
Es wird, nebst dem grundlegenden Server 1, mit einem leistungsfähigen NAS sowie mit LTO gearbeitet werden. Die Bänder werden extern in einem vor höheren Mächten geschützten Tresor aufbewart werden. Ein Band kann ungefähr 45 TB speichern und kostet ungefähr 150 CHF. Die Preise und Leitungen der Bänder können jedoch stark variieren. Beim Wahl des NAS fiel diese auf eine Synology 12-bay DiskStation AMD Ryzen V1500B quad (DS2422+). Die Anschaffungskosten liegen bei ungefähr 2000 CHF. Die zusätzlichen Anschaffungkosten für die benötigen Disks liegen bei ungefähr 6000 CHF. Diese Kosten decken die physische Infrastruktur für das gesamte Backupkonzept ab. Für die Bereiche Server 2 und Server 3 fallen lediglich die Kosten für die zu verwendeten LTO Bänder an. Die Gesamtkosten für jene werden jedoch aufgrund ihrer Unberechenbarkeit erst später dargelegt. Diese Infrastruktur kann sehr gut skaliert und über eine längere Zeit betrieben werden. Zusätzlich sind die Betriebskosten nicht sonderlich hoch.

### Backupsoftware
Als Backupsoftware wird Veeam verwendet werden. Die Kosten für einen Betrieb über 5 Jahre liegen bei ungefähr 5500 CHF. Dieser Preis kann sich jedoch im Verlauf der 5 Jahre ändern. Die Applikation spielt jeden Tag um 02:00 Uhr das Backup auf das NAS. Am ersten Sonntag jedes Monats spielt sie zusätzlich die wichtigsten Daten auf Tape (LTO). Mithilfe dieser Software können alle nötigen Aktionen zu einem passenden Preis abgedeckt werden.

## Konfiguration Server 2 (Administration)

### Backup-Art


### Datenmenge


### Backupschema


### Infrastruktur
Der Server 2 nutzt die gleiche Infrastruktur wie der Server 1. Jedoch wird LTO nicht verwendet, da dies für diese Backup Variante nicht benötigt wird. Es wird also nebst dem Server 2 nur das NAS verwendet, um das oben beschriebene Backup durchzuführen.

### Backupsoftware
Wie beim Server 1, kommt auch hier die Applikation Veeam zum Einsatz. Es wird zum Speichern des Backups auf das NAS verwendet.

## Konfiguration Server 3 (Bestellungen / Aufträge)

### Backup-Art


### Datenmenge


### Backupschema


### Infrastruktur


### Backupsoftware

## Legende

### Reflexion
