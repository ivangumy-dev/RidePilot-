# Backup und Wiederherstellung

RidePilot hat drei Dinge, die verloren gehen können. Der Code ist ersetzbar, die anderen
beiden nicht:

| Was | Wo | Ersetzbar? |
|---|---|---|
| Datenbank samt Dokumenten | Neon (bzw. MariaDB bei Infomaniak) | nein |
| Programmcode | GitHub | ja |

Weil die Dokumente in der Datenbank liegen, gibt es nur noch **eine** Sache zu sichern.

## Der einfachste Weg: Export aus der App

Öffne RidePilot, gehe auf **Datenexport** und klicke auf **Alle Daten als ZIP laden**.
Darin sind alle Fahrten, Wartungen, Schäden, Kontakte, Einstellungen **und** die
Originaldateien. Leg dieses ZIP in deine iCloud oder auf eine Festplatte.

Empfehlung: einmal im Monat. Es dauert zehn Sekunden.

## Bei Neon

Der Gratis-Tarif erlaubt eine Wiederherstellung der letzten **sechs Stunden**
(Neon-Dashboard → Projekt → **Restore**). Das hilft gegen einen Fehler von heute Morgen,
nicht gegen einen, der drei Wochen unbemerkt blieb. Das ZIP oben bleibt deshalb die
eigentliche Sicherung.

Ein vollständiger Datenbankabzug ist bei Neon nur über die Kommandozeile möglich
(`pg_dump`). Für den privaten Betrieb reicht der ZIP-Export vollständig aus.

## Backup durch Infomaniak (nur beim Betrieb dort)

Infomaniak sichert Webhostings und Datenbanken automatisch.

**Manager → Web-Hosting → Backup und Wiederherstellung**

Dort siehst du die verfügbaren Zeitpunkte und kannst einzelne Dateien oder die ganze
Datenbank zurückholen. Prüfe einmal nach der Installation, dass diese Sicherung für
dein Hosting aktiv ist.

## Datenbank selbst sichern (nur bei Infomaniak)

**Manager → Web-Hosting → Datenbanken → phpMyAdmin**

1. Links auf die Datenbank `ridepilot` klicken
2. Oben auf **Exportieren** klicken
3. Exportmethode **Schnell**, Format **SQL**
4. Auf **OK** klicken – die `.sql`-Datei landet in deinen Downloads

## Wiederherstellen

**Datenbank**
1. phpMyAdmin öffnen, Datenbank `ridepilot` anklicken
2. Oben auf **Importieren**, die `.sql`-Datei wählen, auf **OK** klicken

**Anwendung**
Bei Vercel: nichts zu tun – der Code liegt in GitHub und wird bei jeder Änderung neu
veröffentlicht. Bei Infomaniak: `ridepilot.zip` hochladen und entpacken, `.env` behalten,
dann **Build ausführen** und **Neustarten**.

## Automatische Aufräumarbeiten

Der tägliche Cronjob (bei Vercel `/api/cron`, sonst `node scripts/cron-notifications.mjs`)
löscht abgelaufene Sitzungen
und alte Anmeldeversuche und wendet deine Aufbewahrungsfrist für Fahrten an. Diese Frist
stellst du in der App unter **Einstellungen** ein; Standard ist "nie automatisch löschen".

## Testen, ob das Backup taugt

Ein Backup, das nie zurückgespielt wurde, ist eine Vermutung. Öffne einmal das
exportierte ZIP und prüfe, ob `daten.json` deine Fahrten enthält und der Ordner
`dokumente/` deine Dateien. Zwei Minuten, einmal im Jahr.
