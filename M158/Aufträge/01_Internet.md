# Auftrag 01 Internet
### Modul 158

Es folgen Fragen, zu der Theorie, welche in diesem Auftrag vermittelt wurde.
Link zur Theorie: https://gitlab.com/ch-tbz-it/Stud/m158/-/blob/main/04_Unterrichtsressourcen/00_Theorie/01_Internet.md?ref_type=heads

*Erkläre in eigenen Worten was passiert, wenn du https://tbz.ch in den Browser eingibst. Gehe auf DNS, IP-Adresse und HTTPS ein.*
Es wird kontrolliert ob für diese Adresse auf dem Gerät selbst ein DNS-Eintrag (sprich die dazugehörige IP-Adresse) hinterlegt wurde. Ist dem so, wird mit dieser IP-Adresse der entsprechende Server über das HTTPS angesprochen.


*Was ist der Unterschied zwischen einer privaten und einer öffentlichen IP-Adresse?*
Private IP-Adressen werden für das eigene Netzwerk vergeben und sind auch nur von dort aus gültig. So kann viel Traffic im eigenen Netz behalten werden. Wenn man von aussen zugreifen möchte, muss man die öffentliche IP-Adresse verwenden.

*Warum braucht es DNS – könnte man nicht einfach die IP-Adresse direkt eingeben?*
Das hat keinen technischen Grund. Es DNS nur, weil wir Menschen uns die IP-Adressen aller für uns relevanten Seiten merken können.

*Was bedeutet der HTTP-Statuscode 301? In welchem Zusammenhang begegnet dir dieser im Modul 158?*
Der Status bedeutet 301 bedeutet, dass die angefragte Seite dauerhaft umgezogen ist. Es wird in diesem Modul wohl ein Zeichen werden, dass die Migration stattgefunden hat.

*Erkläre den Unterschied zwischen HTTP und HTTPS. Warum sollte heute kein produktiver Webserver mehr auf HTTP laufen?*
HTTP steht für HyperText Transfer Protocol. HTTPS steht für HyperText Transfer Protocol Secure. Dies da ein Zertifikat, welches von einer vertrauenswürdigen Quelle ausgegeben wurde, bestätigt, dass es sich um ein legitime Seite handelt. Da es in der heutigen Zeit sehr wichtig ist, vertrauenswürdig zu sein, sind solche Zertifikat beinahe Pflicht. Ausnahmen bilden jedoch etwa FW, da dort eh nur Personen zugreifen, die (hoffentlich) wissen was sie tun.

*Erkläre den TLS Handshake: Warum wird zuerst asymmetrische und danach symmetrische Verschlüsselung verwendet?*


*Was ist Split-DNS und in welcher Situation macht es Sinn?*


*Du hast einen internen Server mit der Domain server.local. Kann dieser ein gültiges Let's Encrypt Zertifikat erhalten? Begründe deine*
*Antwort und erkläre eine mögliche Alternative.*


*Was sind GLUE Records und warum sind sie notwendig?*