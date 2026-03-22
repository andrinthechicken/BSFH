# Projekt: Konzept planen
### Modul 143

Es folgt die Dokumentation zu folgenden Auftrag: 
https://gitlab.com/ch-tbz-it/Stud/m143/-/blob/main/02-Datensicherungskonzept/03-Planung/Konzept_planen_v2.3.pdf?ref_type=heads  

Alle diese Angaben sind auf einen Betrieb von 5 Jahren ausgelegt. Eine Verlängerung des Betriebes ist aufgrund der verwendeten Infrastruktur jedoch problemlos möglich.


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
Da es sich bei den Korrespondenzdatem um mitunter geschäftsrelevate Daten handelt, wird das Backup vor Ort durchgeführt. Die Daten werden regelmässig auf das NAS gespielt und für 10 Wochen aufbewahrt. Es gilt hier zu erwähnen, dass zur vollständigen IT-Landschaft wohl noch entsprechende Sicherungsmöglichkeiten von Korrespondenzen gehören werden. Diese werden hier jedoch nicht weiter dargelegt und sind nicht Teil dieses Projektes.

### Datenmenge
Zum Zeitpunkt des Go Live wird mit einer ungefähren Datenmenge von 5.5 TB gerechnet. Es wird ein Zuwachs von 5-10% pro Jahr erwartet. Aufgrund der gross ausgelegten Infrstruktur würde auch ein Ausbruch der Datenmenge von 20% kein Problem darstellen. Die maximale Speicheranforderung an das NAS durch die Korrespondenzaten liegt nach 5 Jahren bei ungefähr 80 TB. Wie es zu dieser Zahl kommt, ist unter "Backupschema" dargelegt.

### Backupschema
Das Backup wird jeden Samstag durch die Applikation Veeam um 05:00 Uhr durchgeführt. Veeam spielt das Backup auf das NAS, welches RAID 6 verwendet. Der maximale Speicherverbrauch eines einzigen Backups beträgt demnach, nach 5 Jahren, 8 TB. Es werden die Backups der letzten 10 Wochen aufbewahrt. Sobald diese 10 Wochen abgelaufen sind, wird das Backup der Woche 1 gelöscht. Nach der Woche 11 wird das Backup der Woche 2 gelöscht. Dieser Vorgang wird stehts weitergeführt. Dadurch sind nie mehr als 10 Backups und damit 80 TB  Belastung für das NAS vorhanden.

### Infrastruktur
Der Server 2 nutzt die gleiche Infrastruktur wie der Server 1. Jedoch wird LTO nicht verwendet, da dies für diese Backup Variante nicht benötigt wird. Es wird also nebst dem Server 2 nur das NAS verwendet, um das oben beschriebene Backup durchzuführen.

### Backupsoftware
Wie beim Server 1, kommt auch hier die Applikation Veeam zum Einsatz. Es wird zum Speichern des Backups auf das NAS verwendet. Ein Backup auf LTO ist, wie oben erwähnt, nicht nötig.


## Konfiguration Server 3 (Bestellungen / Aufträge)

### Backup-Art
Das Backup des Servers 3 wird on-premise durchgeführt. Dies, da ein schneller Zugriff auf die Bestellungen und Aufträge stehts möglich sein muss und die Daten möglichst in Kontrolle der Firma sein sollen. Die Daten werden regelmässig auf das NAS gespielt und dort 25 Wochen lang gespeichert. Anschliessend werden die Daten auf Tape (LTO) geschrieben und aufbewahrt.

### Datenmenge
Zum Zeitpunkt des Go Live wird mit einer ungefähren Datenmenge von 6.3 TB gerechnet. Es wird ein Zuwachs von 10% pro Jahr erwartet. Die maximale Speicheranforderung an das NAS durch die Korrespondenzaten liegt nach 5 Jahren bei ungefähr 40 TB. Wie es zu dieser Zahl kommt, ist unter "Backupschema" dargelegt.

### Backupschema
Es wird hier in Zyklen gespeichert. In der ersten Woche eines Zyklus wird am Montag um 02:00 ein Full Backup gemacht. In den darauf folgenden 4 Wochen wird am Montag um 02:00 Uhr jeweils ein inkrementelles Backup gemacht. Nach diesem Zyklus (5 Wochen) beginnt der nächste. Dies ebenfalls mit einem Full Backup. Jegliche, in diesem Abschnitt beschriebenen, Backups werden auf dem NAS gespeichert. Es bleiben jeweils die letzten 5 Zyklen auf dem NAS bestehen. Sobald der 6. Zyklus beginnt, wird der erste gelöscht. Dieser Prozess wird für die weiteren Zyklen so weitergeführt. Damit sind auf dem NAS jeweils die letzten 25 Wochen gespeichert. Zusätzlich werden die Daten regelmässig auf LTO geshrieben und extern an einem vor höheren Mächten geschützten Ort aufbewahrt. Alle 25 Wochen, also exakt 5 Zyklen, werden die gesamten Daten auf dem NAS auf Tape (LTO) gespielt. Diese Bänder werden über einen, durch den Kunden noch zu definierenden, Zeitraum aufbewahrt.

### Infrastruktur


### Backupsoftware

## Legende

### Reflexion
