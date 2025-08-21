# Phase 1: Bauphase
FROM node:lts-alpine AS builder

# Arbeitsverzeichnis festlegen
WORKDIR /app

# Abhängigkeitsdateien kopieren und installieren
COPY package.json package-lock.json ./
RUN npm ci

# Anwendungscode kopieren
COPY . .

# Anwendung bauen
RUN npm run build

#   Phase 2: Produktionsphase
FROM nginx:alpine

# Arbeitsverzeichnis festlegen
COPY --from=builder /app/dist /usr/share/nginx/html

# Port 80 freigeben
EXPOSE 80

# Einen Check einrichten, um sicherzustellen, dass der Server läuft
HEALTHCHECK CMD curl --fail http://localhost:80 || exit 1
