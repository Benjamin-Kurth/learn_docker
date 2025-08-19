● Das "Works on my machine"-Problem: Welchen entscheidenden Vorteil bietet
dein Docker-Container im Vergleich dazu, wenn du einem Kollegen einfach nur
deinen Code-Ordner schicken würdest?

Der entscheidende Vorteil eines Docker-Containers gegenüber dem bloßen Verschicken eines Code-Ordners ist, dass der Container die gesamte Laufzeitumgebung (inkl. Betriebssystem, Abhängigkeiten und Konfiguration) isoliert und portabel macht. Dadurch wird sichergestellt, dass die Anwendung überall, auf jedem Rechner, exakt gleich läuft und das bekannte "Works on my machine"-Problem vermieden wird.

● Blaupause für die Infrastruktur: Erkläre in deinen eigenen Worten, warum das
Dockerfile als "Infrastructure as Code" bezeichnet werden kann.

Ein Dockerfile kann als "Infrastructure as Code" bezeichnet werden, weil es eine textbasierte, automatisierbare Blaupause für die Erstellung einer Software-Infrastruktur ist. Statt die Infrastruktur (wie ein Server mit installierter Software) manuell einzurichten, beschreibt das Dockerfile in klaren, reproduzierbaren Schritten, wie das endgültige Image zu bauen ist.  Das bedeutet, man kann die gesamte Konfiguration des Servers wie z.B. das Betriebssystem, die installierten Pakete, und die Umgebungsvariablen in einer Versionskontrolle wie Git speichern und wie normalen Code behandeln. Dies ermöglicht es, die Infrastruktur zu versionieren, zu testen und automatisch zu deployen, was die Konsistenz und Reproduzierbarkeit verbessert.

● Trennung von Code und Abhängigkeiten: Warum ist es (insbesondere bei
Node.js und Python) eine gute Praxis, die Abhängigkeiten (node_modules oder
virtuelle Umgebungen) nicht direkt in das Image zu kopieren, sondern sie durch
einen RUN-Befehl im Dockerfile installieren zu lassen?

Es ist eine gute Praxis, Abhängigkeiten nicht direkt in das Image zu kopieren, sondern sie stattdessen mit einem RUN-Befehl im Dockerfile installieren zu lassen, weil dies zu einer besseren Nutzung des Docker-Cache führt. Wenn sich nur der Quellcode ändert, aber die Abhängigkeiten nicht, kann Docker die bereits heruntergeladenen Abhängigkeiten aus dem Cache wiederverwenden. Das beschleunigt den Build-Prozess erheblich. Zusätzlich werden die Images kleiner und sicherer, da keine sensiblen Informationen aus den virtuellen Umgebungen direkt in das finale Image gelangen.

● Ports: Was ist der Unterschied zwischen dem Port, den du mit EXPOSE im
Dockerfile angibst, und dem Port, den du im docker run -p Befehl verwendest?

Der EXPOSE-Befehl im Dockerfile ist lediglich eine Dokumentation oder eine Empfehlung 📝. Er teilt dem Benutzer mit, welche Ports im Container-Image für die Anwendung verwendet werden. Der Container selbst ist auf diesen Port noch nicht von außen erreichbar.

Der -p-Befehl (oder --publish) bei docker run ist der eigentliche Befehl, der die Portweiterleitung vom Host-System zum Container-Port herstellt. Er ermöglicht den Zugriff von außerhalb des Containers auf die im Container laufende Anwendung. Man kann damit z.B. Port 8080 des Hosts auf Port 3000 des Containers mappen (-p 8080:3000).







