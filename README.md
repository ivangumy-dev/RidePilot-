# RidePilot

Statische Progressive Web App für Fahrtenbuch, Wartung und Dokumente rund um den Roller.

## Lokal starten

Da die App rein statisch ist, reicht ein einfacher Webserver im Projektordner:

```bash
cd /home/runner/work/RidePilot-/RidePilot-
python -m http.server 8000
```

Danach im Browser öffnen:

```text
http://127.0.0.1:8000/index.html
```

Service Worker und Offline-Cache funktionieren jetzt auch auf `localhost` bzw. `127.0.0.1`.