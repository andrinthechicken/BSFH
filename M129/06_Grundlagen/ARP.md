# ARP
### Modul 129

## Auftrag 1
Beantworte die folgenden Fragen anhand des Szenarios, welches in der, mit Wireshark ausführbaren, Datei dargestellt ist.  
Link zu dieser Datei: https://gitlab.com/ch-tbz-it/Stud/m129/-/blob/main/06_Einstieg/02_ARP/ARP_example_capture.pcapng 

#### *Welche beide IPv4-Adressen bzw. Hosts möchten miteinander kommunizieren?*
192.168.1.20 und 192.168.1.30

#### *Welche MAC-Adresse und IP-Adresse haben die beiden Hosts?*
192.168.1.20 und 192.168.1.30, sowie 00:50:79:66:68:00 und 00:50:79:66:68:01 

#### *Welcher Befehl wurde höchstwahrscheinlich auf dem einten Host ausgeführt?*
Ping 192.168.1.30

#### *An welche MAC-Adresse wurde der ARP-Request geschickt?*
ff:ff:ff:ff:ff:ff (Broadcast) 

#### *An welche MAC-Adresse geht der ARP reply und weshalb macht dieser Empfänger Sinn?*
00:50:79:66:68:00. Es ist der Sender der ersten "Nachricht" und hat um eine Rückmeldung an seine IP-Adresse gebeten.

#### *Was ist die RTT des ersten erfolgreichen "ICMP - ECHO (ping)"?*
Berechnung siehe oben verlinkte Datei:  
3: 0.001077s  
4: 0.001542s  
= 0.000465s  

(Bei RTT muss stehts Differenz zwischen den beiden Anfragezeiten angegeben werden)
#### *Welche beiden Layer gemäss OSI-Referenzmodell verknüpft ARP?*
2 und 3.

#### *Weshalb können zwei über einen Ethernet-Switch verbundene Hosts ohne ARP nicht mit IPv4 kommunizieren?*
Weil Switches nur mit MAC-Adressen arbeiten. Die IP-Adressen können sie erst durch ARP erfahren.