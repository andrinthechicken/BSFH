# Theorie
### Modul 129

*24.02.2026*
## IP-basierte Kommunikation
Die Basis der IP-basierten Kommunikation, die vor allem im zivilen Sektor zahlreiche andere Technologien abgelöst hat und eine der wichtigsten Säulen der globalen Vernetzung darstellt, wurde durch das ARPANet gelegt. Dieses Netzwerk, das ab 1968 im Auftrag der US Air Force entwickelt wurde, ebnete den Weg für die digitale Revolution. ARPANet, der Vorläufer des heutigen Internets, spielte eine entscheidende Rolle bei der Entwicklung des Internetprotokolls (IP), das heute die Grundlage für den Austausch von Daten über das weltweite Netz bildet.

## IMP / Interface Message Processor
Der Interface Message Processor (IMP) war der Knotenpunkt für Paketvermittlung, der zur Verbindung von Teilnehmernetzwerken mit dem ARPANET von den späten 1960er Jahren bis 1989 verwendet wurde. Er war quasi der erste Router.

## ARP
Mit dem ARP-Protokoll kann ein Host die MAC-Adresse eines anderen Hosts herausfinden. Dies ist notwendig, um anschliessend per IPv4 kommunizieren zu können. Es wird über den Broadcast von Host A die Nachricht abgesetzt, dass man erfahren möchte, wer eine spezifische IP-Adresse hat. Der Host B, derjenige mit dieser IP-Adresse, antwortet mit seiner MAC-Adresse. Host A, welcher die Anfrage gesendet hat, erstellt bei sich einen Eintrag mit der Kombination von IP-Adresse und MAC-Adresse. Nun kann er mit Host B über IPv4 kommunzieren.