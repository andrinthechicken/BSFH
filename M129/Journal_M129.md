# Lernjournal
### Modul 129

*Da es bereits eine Datei mit der gesamten Theorie des Moduls und Files mit Lösungen unu Lösungswegen zu den einzelnen Aufträgen gibt, ist dieses Lernjournal bewusst kurz gehalten*

## Einleitung
Im Modul 129 geht es hauptsächlich darum, das Wissen um Netzwerke zu erweitern und in praktischen Übungen Netzwerke zu planen und Tests zu dessen Funktionalität durchzuführen. In der Datei Theorie sind sowohl Informationen zur Historie der Netzwerkkommunikation, als auch Anleitungen zu gewissen Schritten, welche beim Aufbauen eines Netzwerkes nötig sind.

## Auszug aus der Theorie

### IP-Adressen berechnen

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

### Hostmaximum in einem Subnetz berechnen
Wieviele Hosts in ein Netz passen kann mit der folgenden Formel berechnet werden:
Hosts = **2^(Host-Bits) - 2**  
Die Minus zwei entsteht durch den Broadcast und die Netzadresse.

**Beim Subnetting sollen stehts nur so viele Adressen freigegeben werden wie nötig**  


## Auszug aus den Aufgaben
![Beispiel einer Aufgabe zur IP-Berechnung](image-1.png)
![Lösung zur IP-Berechnungsaufgabe](image.png)



## Fazit / Rückblick
Es ist anzumerken, dass mir zu diesem Zeitpunkt einiges an Wissen gefehlt hat. So können Fehler entstanden sein. Ab besten sollte dieses Wissen noch einmal überprüft werde, bevor es verwendet wird. Das Wichtigste das ich aus diesem Modul mitnehme ist sicher das neue Wissen rund um das Subnetting und Berechnen von IP-Adressen. Daher sind in diesem Journal auch die Theorie hierzu und eine Aufgabe dazu eingebetet. Dieses Modul hat mir einige Mühe bereitet, da ich in diesem Bereich noch viel aufzuholen habe.