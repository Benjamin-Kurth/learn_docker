# Basis-Image mit dem Nginx Webserver
FROM nginx:alpine

# Kopiere den Inhalt des 'src'-Ordners in das Web-Verzeichnis von Nginx
COPY src/ /usr/share/nginx/html/

# Mache deutlich, dass der Container auf Port 80 lauscht
EXPOSE 80
