# Theorie
### Modul 129

*24.02.2026*
## IP-basierte Kommunikation
Die Basis der IP-basierten Kommunikation, die vor allem im zivilen Sektor zahlreiche andere Technologien abgelöst hat und eine der wichtigsten Säulen der globalen Vernetzung darstellt, wurde durch das ARPANet gelegt. Dieses Netzwerk, das ab 1968 im Auftrag der US Air Force entwickelt wurde, ebnete den Weg für die digitale Revolution. ARPANet, der Vorläufer des heutigen Internets, spielte eine entscheidende Rolle bei der Entwicklung des Internetprotokolls (IP), das heute die Grundlage für den Austausch von Daten über das weltweite Netz bildet.

## IMP / Interface Message Processor
Der Interface Message Processor (IMP) war der Knotenpunkt für Paketvermittlung, der zur Verbindung von Teilnehmernetzwerken mit dem ARPANET von den späten 1960er Jahren bis 1989 verwendet wurde. Er war quasi der erste Router.

## ARP
Mit dem ARP-Protokoll kann ein Host die MAC-Adresse eines anderen Hosts herausfinden. Dies ist notwendig, um anschliessend per IPv4 kommunizieren zu können. Es wird über den Broadcast von Host A die Nachricht abgesetzt, dass man erfahren möchte, wer eine spezifische IP-Adresse hat. Der Host B, derjenige mit dieser IP-Adresse, antwortet mit seiner MAC-Adresse. Host A, welcher die Anfrage gesendet hat, erstellt bei sich einen Eintrag mit der Kombination von IP-Adresse und MAC-Adresse. Nun kann er mit Host B über IPv4 kommunzieren.

## IP-Adressen berechnen

*Nehmen wir die IPv4-Adresse 192.168.6.4/24 und beantworten dazu, die relevanten Fragen:*

*Ist die vorliegende IPv4-Adresse eine Netz-, Broadcast- oder Host-Adresse?*
*Wie lautet die Netzadresse?*
*Wie lautet die Broadcast-Adresse?*
*Wie viele Hosts können adressiert werden?*
*Welche IPv4-Adressen stehen für die Host-Adressierung zur Verfügung?*

### Schritt 1: IPv4 Adresse in binäre Form umwandeln
Address:   192.168.6.4          11000000.10101000.00000110. 00000100

### Schritt 2: Netzmaske und Wildcard in binäre Form umwandeln
Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
                                <=        24 Eins       =>
Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
                                                            <8 Eins>
                                24 Bits + 8 Bits = 32 Bits = 4 Bytes

### Schritt 3: Logisch UND (&) mit der IPv4-Adresse & Netzmaske ergibt Netzadresse
Address:   192.168.6.4          11000000.10101000.00000110. 00000100
 & Netmask:   255.255.255.0     11111111.11111111.11111111. 00000000
 = Network:   192.168.6.0/24    11000000.10101000.00000110. 00000000

### Schritt 4: Netzmaske + 1 ergibt HostMin
Network:   192.168.6.0/24       11000000.10101000.00000110. 00000000
+ 1                             00000000.00000000.00000000. 00000001
= HostMin:   192.168.6.1          11000000.10101000.00000110. 00000001

### Schritt 5: Netzmaske & Wildcard = Broadcast
Network:   192.168.6.0/24       11000000.10101000.00000110. 00000000
& Wildcard                      00000000.00000000.00000000. 11111111
 = Broadcast: 192.168.6.255     11000000.10101000.00000110. 11111111

### Schritt 6: Broadcast - 1 ergibt HostMax
Broadcast: 192.168.6.255     11000000.10101000.00000110. 11111111
 -1                          00000000.00000000.00000000. 00000001
 = HostMax: 192.168.6.254    11000000.10101000.00000110. 11111110

### Schritt 7: Anzahl möglicher Hosts bestimmen: 2^(32-CIDR) -2 = Anzahl Hosts
2^(32-24) - 2 = 254
