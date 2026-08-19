# RidePilot

Fahrtenbuch, Wartung, Dokumente und Notfallangaben für einen Elektroroller (Volta VSX, 25 km/h).
Progressive Web App für iPhone, iPad, Mac und Windows. Läuft auf dem eigenen Hosting in der Schweiz.

**Installation:**
- Gratis bei Vercel + Neon: [VERCEL.md](VERCEL.md) ← der eingeschlagene Weg
- Auf einem Infomaniak-Hosting: [INSTALLATION.md](INSTALLATION.md)

Beide Anleitungen sind Schritt für Schritt geschrieben und kommen ohne Terminal aus.

## Was die App kann

| Bereich | Inhalt |
|---|---|
| Übersicht | Status, letzte Fahrt, Kilometerstand, Batterie, offene Schäden, letzter Standort |
| Schnellzugriff | Drei Tasten auf Dashboard und im Fahrtmodus: Musik-App öffnen, Foto auslösen, vorbereitete Nachricht senden |
| Fahrtmodus | GPS-Aufzeichnung, grosse Anzeige, 1 oder 2 Personen, Rückfrage bei Stillstand |
| Fahrtenbuch | Verlauf, Monats- und Jahresansicht, Notizen, privat markieren, PDF und CSV |
| Karte | Route als Streckenbild, Links zu Apple Karten und OpenStreetMap |
| Batterie | Ladestand erfassen, Ladehistorie, Reichweitenschätzung, Warnung |
| Fahrzeug und Service | Stammdaten, Versicherung, Servicehistorie, Kosten, Erinnerungen |
| Schäden | Erfassen, Fahrbarkeit, Status, Schadenmeldung und Versicherungsübersicht als PDF |
| Dokumente | Ausweis, Belege, Rechnungen, Garantien mit Typprüfung und Suche |
| Diebstahlschutz | Letzter Standort, Geofence, Alarmverlauf |
| Notfall | Notrufe, Notfallkontakte, Standort senden, offline verfügbar |
| Kontakte und Nachrichten | Vertrauenspersonen, vorbereitete Sätze statt Tippen |
| Audio und Sprache | Musik starten, Anleitungen für Siri-Kurzbefehle und Bluetooth-Automationen |
| Einstellungen | Stillstandszeit, Karten, Aufbewahrung, Schnellzugriff, Passwort, Zahlencode |
| Anmeldung | E-Mail und Passwort, danach wahlweise sechsstelliger Code auf dem bekannten Gerät |
| Datenexport | Vollständiger ZIP-Export, PDF-Berichte, CSV-Tabellen, komplette Löschung |

## Technik

- Next.js 14 (App Router) mit TypeScript im Strict Mode
- Tailwind CSS, dunkles Design, grosse Bedienflächen
- Prisma mit PostgreSQL (für MariaDB/MySQL nur `provider` in `prisma/schema.prisma` ändern und `directUrl` entfernen)
- Sitzungen in der Datenbank, Passwörter mit Argon2id (hash-wasm, kein Compiler nötig)
- Zod für jede Eingabe, Rate Limiting bei der Anmeldung, Audit-Log
- PDF mit pdf-lib, ZIP-Export ohne externe Abhängigkeit
- PWA mit Manifest, Service Worker und Offline-Seite

## Lokal starten

```bash
npm install
cp .env.example .env      # DATABASE_URL und DIRECT_URL eintragen
npx prisma db push
npm run dev               # http://localhost:3000
```

Beim ersten Aufruf leitet die App auf `/setup` und legt dort das Eigentümerkonto an.
Alternativ im Terminal: `npm run setup:owner`.

## Ordnerstruktur

```
prisma/schema.prisma    Datenmodell (21 Tabellen)
vercel.json             Region Frankfurt und täglicher Cronjob
scripts/                Ersteinrichtung und Cron-Aufruf für den Eigenbetrieb
src/app/(app)/          Alle Seiten nach Anmeldung
src/app/api/            Alle Endpunkte, inkl. /api/cron
src/lib/                Datenbank, Sitzungen, Validierung, PDF, ZIP, Geo, Unterhalt
src/components/         Navigation, Karten, Hinweise
public/                 Manifest, Service Worker, Offline-Seite, Icons
```

Hochgeladene Dokumente liegen in der Datenbank, nicht im Dateisystem – auf Vercel gäbe es
keinen dauerhaften Ordner dafür.

## Bewusste Grenzen

Diese Punkte sind keine Lücken, sondern Entscheidungen. Details in [SICHERHEIT.md](SICHERHEIT.md).

- **Keine Fahrzeugdaten.** Der Volta VSX hat keine offene Schnittstelle. Batteriestand und
  Kilometerstand werden erfasst, nicht ausgelesen. Die App zeigt nie erfundene Sensorwerte.
- **Kein Ein- und Ausschalten von Bluetooth-Lautsprechern.** Weder iOS noch Android erlauben
  das aus einer Web-App. Stattdessen: Anleitungen für Siri-Kurzbefehle und Automationen.
- **Keine Hintergrundortung.** Ein Browser meldet den Standort nur bei geöffneter App.
  Für dauerhafte Ortung braucht es einen AirTag oder GPS-Tracker.
- **Keine Sturzerkennung.** Das bleibt bei Apple Watch und iPhone. Der Notruf läuft immer
  über die Telefonfunktion.
- **Kein Eingriff ins Fahrzeug.** Geschwindigkeit, Bremsen und Motorsteuerung werden weder
  gelesen noch verändert.
- **Keine externen Dienste.** Kein Wetter, keine Kartenkacheln, keine Analyse. Erst wenn du
  einen Kartenlink öffnest, verlässt eine Koordinate dein Gerät.
- **Dateien höchstens 4 MB.** Auf Vercel darf eine Anfrage nicht grösser sein. Fotos werden
  deshalb schon im Browser verkleinert, bevor sie hochgeladen werden.

## Rechtliches

Die Datenschutztexte in [DATENSCHUTZ.md](DATENSCHUTZ.md) und in der App sind **anpassbare
Vorlagen für den privaten Eigenbetrieb**. Sie sind keine Rechtsberatung, und es wird nicht
behauptet, dass diese Software rechtskonform sei. Vor einem öffentlichen Betrieb gehört das
Projekt juristisch geprüft und um ein Impressum ergänzt.
