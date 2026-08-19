# Infomaniak – Einstellungen im Überblick

Die vollständige Anleitung steht in [INSTALLATION.md](INSTALLATION.md).
Diese Datei ist die Kurzreferenz zum Nachschlagen.

## Node.js-Einstellungen

Manager → Web-Hosting → Website anklicken → **Erweiterte Parameter verwalten** → Registerkarte **Node.js**

| Feld | Wert |
|---|---|
| Ausführungsverzeichnis | `./` |
| Build-Befehl | `npm install && npx prisma generate && npx prisma db push && npm run build` |
| Startbefehl | `npm start` |
| Node.js-Version | LTS, mindestens 20 |
| Listening Port | Vorgabe von Infomaniak übernehmen |

Der Port kommt über die Umgebungsvariable `PORT` in die Anwendung. Next.js übernimmt
ihn automatisch – im Code ist nichts fest verdrahtet.

Nach jeder Änderung im Manager: **Speichern**, dann im Dashboard **Neustarten**.

## Umgebungsvariablen

Die Werte stehen in der Datei `.env` im Stammverzeichnis der Website.

```
DATABASE_URL="mysql://ridepilot_user:PASSWORT@SERVER:3306/ridepilot"
NEXT_PUBLIC_APP_URL="https://ridepilot.ch"
MAX_UPLOAD_MB=15
NODE_ENV=production
```

Die `.env` gehört **nicht** ins Git-Repository. Sie steht bereits in `.gitignore`.

## Datenbank

Manager → Web-Hosting → **Datenbanken**

- Typ: MariaDB
- Name: `ridepilot`
- Benutzer: `ridepilot_user`
- Port: `3306`

Beim Wechsel auf PostgreSQL genügt in `prisma/schema.prisma`:
`provider = "postgresql"` und eine passende `DATABASE_URL`.

## Datenbankänderungen nach einem Update

Das Schema wird beim Build automatisch angeglichen (`npx prisma db push`).
Bei grösseren Umbauten vorher ein Backup ziehen – siehe [BACKUP.md](BACKUP.md).

## Cron

Manager → Hosting → **Cron-Aufgaben**

| Feld | Wert |
|---|---|
| Befehl | `node scripts/cron-notifications.mjs` |
| Verzeichnis | Ordner der Website |
| Häufigkeit | täglich, 06:00 |

## HTTPS und Domain

Manager → Website → **SSL-Zertifikate** → **Let's Encrypt** → danach **HTTPS erzwingen**.

Ohne HTTPS funktionieren Standortzugriff, Service Worker und die Installation als App nicht.

## Deployment über Git statt ZIP

Infomaniak kann den Quellcode auch aus einem Git-Repository holen. Der Build-Befehl wird dann:

```
git pull && npm install && npx prisma generate && npx prisma db push && npm run build
```

Nutze für RidePilot ein **privates** Repository. Der Code selbst enthält keine Geheimnisse,
aber private Projekte gehören nicht öffentlich ins Netz.

## Wo die Protokolle stehen

Dashboard der Website → **Ausführungskonsole**. Dort landen Startfehler und Laufzeitfehler.
Passwörter, Sitzungsschlüssel und Dateiinhalte werden nie protokolliert.
