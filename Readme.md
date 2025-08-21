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



● Multi-Stage Build:
Was ist der Hauptvorteil eines Multi-Stage Builds (wie in deinem Dockerfile implementiert)
gegenüber einem einfachen Dockerfile, das alle Schritte in einer einzigen Stage ausführt?

Der Hauptvorteil eines Multi-Stage Builds liegt in der signifikanten Reduzierung der Größe des finalen Images. Das liegt daran, dass nur die für die Laufzeit notwendigen Artefakte in das finale Image kopiert werden, während alle Build-Abhängigkeiten und Zwischenergebnisse aus dem Build-Container verworfen werden.

● Warum ist der node_modules Ordner nicht im finalen Nginx Image enthalten, obwohl er für
den Build-Prozess im ersten Stage notwendig war? Erkläre, wie der Multi-Stage Build dies
ermöglicht.

Der node_modules Ordner ist nicht im finalen Nginx-Image enthalten, weil der Multi-Stage Build dies explizit trennt. Im ersten Stage (build) werden alle Abhängigkeiten (npm ci) installiert und der Build-Prozess (npm run build) ausgeführt. Im zweiten Stage (final) wird ein komplett neues, schlankes Image (nginx:alpine) erstellt. Es werden lediglich die statischen Build-Ergebnisse (der build-Ordner) aus der ersten Stage in das finale Image kopiert, während der node_modules-Ordner und alle anderen Build-Tools nicht übernommen werden.

● Beschreibe, wie das Docker-Layer-Caching bei diesem Multi-Stage Build genutzt wird,
insbesondere im Zusammenhang mit dem COPY package*.json Schritt.

Docker-Layer-Caching wird bei diesem Multi-Stage Build effektiv genutzt. Der Schritt COPY package*.json ./ wird relativ früh im Dockerfile ausgeführt. Da sich die package.json und package-lock.json in der Regel seltener ändern als der eigentliche Quellcode, kann Docker diesen Layer zwischenspeichern. Wenn sich der Code ändert, aber die Abhängigkeiten gleich bleiben, kann der npm ci-Schritt übersprungen werden, weil der Layer davor bereits gecached wurde. Dies beschleunigt den Build-Prozess erheblich.

● Rolle des Webservers und der Anwendung:
Was wird genau im finalen Image gespeichert – der gesamte Quellcode, die
Build-Abhängigkeiten oder das reine Build-Ergebnis (statische Dateien)? Erkläre den
Unterschied zur ersten Stage.

Im finalen Image wird nur das reine Build-Ergebnis (die statischen Dateien wie HTML, CSS, JavaScript) aus dem build-Ordner gespeichert. Der gesamte Quellcode und die Build-Abhängigkeiten sind nicht enthalten. Im Gegensatz dazu enthält die erste Stage (der build-Container) den gesamten Quellcode, alle Entwicklungsabhängigkeiten und die Build-Tools.

● Welche Rolle spielt der Webserver (Nginx) in diesem Kontext der Containerisierung deiner
React-Anwendung? Warum ist eine spezielle Konfiguration für SPAs (wie React) auf einem
Webserver oft notwendig?

Der Webserver Nginx spielt die Rolle des Auslieferers der statischen Dateien. Er nimmt die HTTP-Anfragen entgegen und liefert die React-Anwendung an den Browser des Benutzers aus. Eine spezielle Konfiguration für SPAs ist oft notwendig, da Webserver bei einer URL wie /about standardmäßig nach einer Datei mit diesem Namen suchen würden. Da eine SPA aber nur eine einzige HTML-Datei hat, muss der Webserver so konfiguriert werden, dass er alle Anfragen an diese eine Datei (index.html) weiterleitet. Das Routing innerhalb der Anwendung übernimmt dann die React-Router-Bibliothek im Browser.

● Warum wird der Entwicklungsmodus (npm run dev) nicht für den Produktivbetrieb im
Container genutzt?

Der Entwicklungsmodus (npm run dev) wird nicht für den Produktivbetrieb genutzt, weil er für die Entwicklung optimiert ist. Er startet einen Entwicklungsserver mit Hot-Module-Replacement, Live-Reloading und zusätzlichen Debugging-Tools, was im Produktivbetrieb unnötig wäre und zu einer schlechteren Performance führen würde. Für die Produktion wird ein Build erstellt, der optimierte, minimierte und gebündelte Dateien erzeugt, die statisch ausgeliefert werden können.

● Containerisierung und Betrieb:
Was ist der Hauptvorteil der Containerisierung deiner React-Anwendung mit Docker
(basierend auf dem Multi-Stage Build) im Vergleich zur Auslieferung der statischen Dateien
durch einen "lokalen Build" auf dem Server ohne Container? Nenne mindestens zwei
Vorteile (z.B. in Bezug auf Portabilität, Reproduzierbarkeit, Isolation).

Der Hauptvorteil der Containerisierung mit Docker im Vergleich zu einem lokalen Build auf dem Server sind Portabilität und Reproduzierbarkeit.

Portabilität: Das Docker-Image enthält die gesamte Anwendung und ihre Laufzeitumgebung. Es kann auf jedem System, das Docker unterstützt, ausgeführt werden, ohne dass zusätzliche Abhängigkeiten installiert werden müssen.

Reproduzierbarkeit: Der Build-Prozess ist in einem Dockerfile definiert, was sicherstellt, dass die Anwendung auf jedem System exakt auf die gleiche Weise gebaut wird und immer die gleiche Umgebung hat.

● Erkläre die Funktion des HEALTHCHECK in deinem Dockerfile und warum er für die spätere
Orchestrierung (z.B. in Docker Swarm oder Kubernetes) von Bedeutung ist.

Der HEALTHCHECK in deinem Dockerfile prüft, ob der Container und der darin laufende Service (Nginx) tatsächlich funktionsfähig sind. In Orchestrierungssystemen wie Docker Swarm oder Kubernetes nutzt der Orchestrator diese Information, um festzustellen, ob ein Container ordnungsgemäß läuft. Ist ein Container als "unhealthy" markiert, kann er automatisch neu gestartet oder ersetzt werden, was die Verfügbarkeit der Anwendung erhöht.

● Vergleiche die Aufgaben von .gitignore und .dockerignore in deinem Projekt. Welche Datei
beeinflusst den Git-Verlauf und welche den Docker Build-Kontext?

.gitignore beeinflusst den Git-Verlauf und .dockerignore den Docker Build-Kontext.

.gitignore: Gibt an, welche Dateien und Ordner von Git ignoriert und nicht in die Versionskontrolle aufgenommen werden sollen. Dies betrifft typischerweise temporäre Dateien, Build-Ergebnisse oder Umgebungsvariablen (.env).

.dockerignore: Gibt an, welche Dateien und Ordner beim Erstellen des Docker-Images in das Build-Kontext-Verzeichnis ignoriert und nicht an den Docker-Daemon gesendet werden sollen. Dies ist wichtig, um die Größe des Build-Kontextes zu reduzieren und unnötige Dateien (wie den node_modules Ordner) vom Kopiervorgang auszuschließen.

● Namensräume: Warum ist das Format <username>/<repository> für ein öffentliches
Repository wie Docker Hub so wichtig? Was würde passieren, wenn jeder sein Image
einfach nur meine-webseite nennen könnte?

Das Format <username>/<repository> ist für öffentliche Repositories wie Docker Hub entscheidend, um Eindeutigkeit zu gewährleisten. Ohne diese Namensräume könnte jeder sein Image meine-webseite nennen, was zu Namenskonflikten und einem chaotischen System führen würde. Der Namensraum (username) dient als eindeutiger Präfix und stellt sicher, dass jedes Image global identifizierbar ist.

● Tag vs. Build: Was ist der genaue Unterschied zwischen dem Befehl docker tag
alter-name neuer-name und dem Befehl docker build -t neuer-name .? Erstellt docker
tag ein komplett neues Image?

Der Unterschied zwischen docker tag und docker build ist fundamental:

docker build -t neuer-name .: Dieser Befehl erstellt ein neues Image aus dem Dockerfile im aktuellen Verzeichnis und gibt ihm direkt den Namen und Tag neuer-name. Es ist der Prozess, bei dem ein Image generiert wird.

docker tag alter-name neuer-name: Dieser Befehl erstellt kein neues Image. Er weist einem bereits existierenden Image lediglich einen zusätzlichen Alias (neuer-name) zu. Es ist wie ein Pointer oder eine Verknüpfung, die auf dasselbe Image verweist.

● Versionierung: Du hast einen kleinen Fehler in deiner Anwendung gefunden und
behoben. Du baust ein neues Image. Welchen neuen Tag (Version) würdest du ihm
geben (z.B. ...:1.0.1 oder ...:1.1) und warum ist eine saubere Versionierung wichtig?

Wenn du einen kleinen Fehler (einen Bugfix) in deiner Anwendung behebst, ist der neue Tag ...:1.0.1 am passendsten. Dies folgt der semantischen Versionierung (MAJOR.MINOR.PATCH).

PATCH (.0.1): steht für rückwärtskompatible Bugfixes.

MINOR (.1): steht für rückwärtskompatible neue Features.

MAJOR (1.): steht für inkompatible API-Änderungen.

Eine saubere Versionierung ist wichtig, weil sie es Entwicklern und Operations-Teams ermöglicht, zuverlässig zu wissen, welche Änderungen in einer bestimmten Version enthalten sind, ohne den Code inspizieren zu müssen. Das erleichtert das Deployment und das Rollback im Fehlerfall.

● Öffentlich vs. Privat: Dein Repository auf Docker Hub ist jetzt öffentlich. In welchem
Szenario würdest du unbedingt ein privates Repository verwenden wollen?

Ein privates Repository auf Docker Hub würde man unbedingt verwenden, um vertraulichen Code zu hosten. Dies ist notwendig, wenn das Image proprietäre Software, interne Tools oder andere sensible Daten enthält, die nicht öffentlich zugänglich sein dürfen. Private Repositories erfordern eine Authentifizierung, um das Image zu pullen.

Docker-Hub-Repository:
https://hub.docker.com/repository/docker/benjaminkurth/learn_docker/general