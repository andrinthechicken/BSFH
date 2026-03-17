# Projekt: Konzept planen
### Modul 143

Es folgt die Dokumentation zu folgenden Auftrag: 
https://gitlab.com/ch-tbz-it/Stud/m143/-/blob/main/02-Datensicherungskonzept/03-Planung/Konzept_planen_v2.3.pdf?ref_type=heads

*Server 1 detailierter*
## Konfiguration Server 1 (MA-Daten)

### Backup-Art
Das Backup der Daten des Servers 1 wird zur besseren Überwachung respektive Kontrolle on-premise durchgeführt werden. Hierfür wird ein NAS zum Einsatz kommen. Da bisher keine Backupinfrastruktur vorhanden war, ist eine Migration nicht nötig. Die wichtigsten Daten aus diesem Datenpool werden zusätzlich regelmässig auf Tape geschrieben und offsite gelagert. Diese Tapes werden nach Ablauf der Aufbewarungszeit fachgerecht entsorgt.

### Datenmenge
Zum Zeitpunkt des Go Live wird die Datenmenge verraussichtlich rund 25.5 TB betragen. Pro Jahr wird ein Zuwachs von rund 1 TB erwartet. Hier sind mögliche neue Mitarbeiter bereits eingerechnet. Aufgrund der Stabilität der Firma ist kein Ein- oder Ausbruch des Volumens zu erwarten.

### Backupschema
Das Backup auf das Backup-NAS wird jede Nacht gegen 02:00 Uhr durchgeführt werden. Es ist mit keinen Unterbrüchen im Netzwerkbetrieb zu rechnen. Am ersten Sonntag des Monats werden die essentiellen Daten zusätzlich auf Tape (LTO) gespielt.

### Infrastruktur
Es wird, nebst dem grundlegenden Server 1, mit einem leistungsfähigen NAS sowie mit LTO gearbeitet werden.  

### Backupsoftware


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
