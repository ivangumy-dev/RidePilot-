# RidePilot gratis betreiben: Vercel + Neon

**Schritt für Schritt, Klick für Klick, Fenster für Fenster.**
Kein Terminal, keine Kreditkarte, keine monatliche Rechnung.

Was du am Ende hast:

| Teil | Anbieter | Kosten |
|---|---|---|
| Anwendung | Vercel, Tarif **Hobby** | 0 |
| Datenbank | Neon, Tarif **Free** | 0 |
| Quellcode | GitHub, privates Repository | 0 |
| Domain `ridepilot.ch` | bleibt bei Infomaniak | zahlst du bereits |

Zeitbedarf: etwa 50 Minuten.

> **Ehrlich vorweg:** Gratis-Tarife sind ein Versprechen auf Zeit. Vercel und Neon können ihre
> Bedingungen jederzeit ändern. Deine Daten kommen aber jederzeit vollständig als ZIP wieder
> heraus, und derselbe Code läuft ohne Änderung auch auf Infomaniak. Du bist nicht eingesperrt.

---

## Teil 0 – Was sich gegenüber der Infomaniak-Variante ändert

Ich habe den Code für diesen Weg angepasst. Drei Dinge sind anders:

1. **Die Datenbank ist PostgreSQL** statt MariaDB. Für dich ändert sich nichts.
2. **Dokumente liegen in der Datenbank**, nicht in einem Ordner. Auf Vercel gibt es keinen
   dauerhaften Ordner – nach jeder Veröffentlichung wäre er leer.
3. **Dateien sind auf 4 MB begrenzt.** Vercel nimmt pro Anfrage nicht mehr entgegen. Fotos
   verkleinert die App deshalb automatisch im Browser, bevor sie hochgeladen werden.

Und ein Punkt, den du kennen musst: **Deine Daten liegen dann nicht mehr in der Schweiz.**
Beide Anbieter sind US-Firmen; die App läuft in ihren Rechenzentren in Frankfurt. Für den privaten
Eigengebrauch ist das unproblematisch, aber die Datenschutzerklärung sagt das jetzt auch so.

---

## Teil 1 – Code zu GitHub

**Fenster: github.com**

1. Öffne `https://github.com` und melde dich an (dein Konto: **ivangumy**).
2. Klicke oben rechts auf **+**, dann auf **New repository**.
3. Fülle aus:
   - **Repository name:** `ridepilot`
   - **Description:** leer lassen
   - Wähle **Private**. Das ist wichtig.
   - Setze **kein** Häkchen bei "Add a README file".
4. Klicke auf **Create repository**.
5. Auf der nächsten Seite klickst du auf den Link **uploading an existing file**.
6. Entpacke auf deinem Computer die Datei `ridepilot.zip`. Du bekommst einen Ordner `ridepilot`.
7. **Öffne diesen Ordner.** Markiere alles darin (⌘A) und ziehe es in das Browserfenster.
   Wichtig: nicht den Ordner selbst hochladen, sondern seinen **Inhalt**.
8. Warte, bis alle Dateien aufgelistet sind – das dauert ein bis zwei Minuten.
9. Klicke unten auf **Commit changes**.

**Kontrolle:** Im Repository müssen jetzt `package.json`, `vercel.json` und die Ordner
`src`, `prisma`, `public` direkt sichtbar sein. Liegt stattdessen ein Ordner `ridepilot`
darin, hast du eine Ebene zu hoch hochgeladen – lösch ihn und wiederhole Schritt 7.

---

## Teil 2 – Datenbank bei Neon

**Fenster: neon.com**

1. Öffne `https://neon.com` und klicke auf **Sign up**.
2. Melde dich mit **Continue with GitHub** an. Dann brauchst du kein zweites Passwort.
3. Neon fragt nach einem ersten Projekt. Fülle aus:
   - **Project name:** `ridepilot`
   - **Postgres version:** die vorgeschlagene
   - **Region:** **Europe (Frankfurt)** – das ist die nächstgelegene.
4. Klicke auf **Create project**.
5. Es erscheint ein Fenster **Connection string**. Darunter ist eine Auswahlliste.
6. **Erster Wert – kopieren und in eine Notiz legen:**
   - Wähle in der Liste **Prisma**, falls vorhanden, sonst **Parameters** → **Connection string**.
   - Achte darauf, dass **Pooled connection** eingeschaltet ist. Der Servername enthält dann `-pooler`.
   - Klicke auf **Copy**. Notiere das als **DATABASE_URL**.
7. **Zweiter Wert:**
   - Schalte **Pooled connection** aus. Der Servername ist jetzt derselbe **ohne** `-pooler`.
   - Klicke auf **Copy**. Notiere das als **DIRECT_URL**.

Beide sehen ungefähr so aus:

```
postgresql://ridepilot_owner:AbCd1234@ep-still-frost-12345678-pooler.eu-central-1.aws.neon.tech/neondb?sslmode=require
```

Falls am Ende `?sslmode=require` fehlt, häng es selbst an.

---

## Teil 3 – Ein Geheimnis für den Cronjob

Öffne deinen Passwortmanager und lass ein Passwort mit **40 Zeichen** erzeugen, Buchstaben und
Zahlen, keine Sonderzeichen. Notiere es als **CRON_SECRET**. Es verhindert, dass Fremde die
tägliche Aufräumroutine auslösen können.

---

## Teil 4 – Veröffentlichen bei Vercel

**Fenster: vercel.com**

1. Öffne `https://vercel.com` und klicke auf **Sign Up**.
2. Wähle **Continue with GitHub** und erlaube den Zugriff.
3. Wähle den Tarif **Hobby** – der ist kostenlos. Gib deinen Namen ein, klicke auf **Continue**.
4. Du landest im Dashboard. Klicke auf **Add New…** und dann auf **Project**.
5. In der Liste **Import Git Repository** suchst du `ridepilot`.
   Erscheint es nicht, klicke auf **Adjust GitHub App Permissions** und erlaube den Zugriff auf
   das Repository.
6. Klicke neben `ridepilot` auf **Import**.
7. Jetzt kommt die Konfigurationsseite. **Bevor du auf Deploy klickst**, öffne den Bereich
   **Environment Variables** und trage nacheinander vier Werte ein.
   Jeweils Name links, Wert rechts, dann auf **Add** klicken:

   | Name | Wert |
   |---|---|
   | `DATABASE_URL` | dein **pooled** Wert aus Teil 2 |
   | `DIRECT_URL` | dein Wert **ohne** `-pooler` aus Teil 2 |
   | `CRON_SECRET` | dein 40-Zeichen-Geheimnis aus Teil 3 |
   | `NEXT_PUBLIC_APP_URL` | `https://ridepilot.ch` |

   **Framework Preset** muss auf **Next.js** stehen. Build Command und Output Directory lässt
   du auf den Vorgabewerten – die Anweisungen stehen bereits in `package.json` und `vercel.json`.

8. Klicke auf **Deploy**.
9. Das dauert **3 bis 6 Minuten**. Du siehst das Protokoll live mitlaufen.
   Beim ersten Durchgang legt RidePilot dabei automatisch alle Tabellen in der Datenbank an.
10. Wenn oben **Congratulations** erscheint, klicke auf **Continue to Dashboard**.

**Wenn es rot abbricht:** Klicke auf **View Build Logs** und lies die letzte Zeile.
Die häufigsten Ursachen stehen unten unter *Wenn etwas nicht klappt*.

---

## Teil 5 – Erster Test unter der Vercel-Adresse

1. Klicke im Dashboard oben auf **Visit**. Es öffnet sich eine Adresse wie
   `ridepilot-xyz.vercel.app`.
2. Du landest auf **Ersteinrichtung**.
3. **Warte damit noch** – leg das Konto erst an, wenn deine eigene Domain steht. Sonst zeigen
   gespeicherte Links später auf die Vercel-Adresse.

Wenn die Seite lädt, funktionieren Anwendung und Datenbank. Das ist der wichtigste Zwischenstand.

---

## Teil 6 – Domain ridepilot.ch verbinden

**Fenster A: Vercel**

1. Klicke im Projekt oben auf **Settings**, links auf **Domains**.
2. Tippe `ridepilot.ch` ein und klicke auf **Add**.
3. Vercel zeigt dir jetzt an, welche DNS-Einträge nötig sind – meistens ein **A-Record** für
   `ridepilot.ch` und ein **CNAME** für `www`. **Schreib die angezeigten Werte genau ab.**
   Verwende immer die Werte, die Vercel dir anzeigt, nicht Werte aus einer Anleitung.

**Fenster B: Infomaniak Manager**

4. Öffne `https://manager.infomaniak.com`, Menü → **Domains** → `ridepilot.ch`.
5. Klicke links auf **DNS-Zone**.
6. **Wichtig:** Notiere dir zuerst, welche Einträge für `ridepilot.ch` bereits existieren, oder
   mach einen Screenshot. Falls dort noch die alte statische Version hängt, wird sie durch diese
   Änderung ersetzt.
7. Bearbeite den bestehenden **A**-Eintrag für `ridepilot.ch` (Feld Quelle leer oder `@`) und
   trage die von Vercel angezeigte IP-Adresse ein. Existiert keiner, lege ihn über
   **Eintrag hinzufügen** an.
8. Lege ebenso den **CNAME**-Eintrag für `www` mit dem von Vercel angezeigten Ziel an.
9. Speichern.

**Zurück zu Vercel**

10. Nach 10 bis 60 Minuten wechselt die Anzeige bei **Domains** auf **Valid Configuration**.
    Das HTTPS-Zertifikat stellt Vercel danach automatisch aus – da musst du nichts tun.
11. Klicke bei `ridepilot.ch` auf die drei Punkte und setze es als **Primary Domain**.

---

## Teil 7 – Dein Konto anlegen

1. Öffne `https://ridepilot.ch` auf dem Telefon.
2. Du landest auf **Ersteinrichtung**. Trage ein:
   - **Dein Name**
   - **E-Mail** – dient als Benutzername
   - **Passwort** – mindestens 10 Zeichen
3. Klicke auf **Konto anlegen**.

> Diese Seite funktioniert genau einmal. Danach ist sie gesperrt und leitet auf die Anmeldung um.

---

## Teil 8 – Roller erfassen

Du landest direkt beim Fahrzeugprofil.

1. **Name:** `Volta VSX`, **Hersteller:** `Volta`, **Modell:** `VSX`
2. **Höchstgeschwindigkeit:** `25`
3. Trage ein, was du zur Hand hast: Baujahr, Seriennummer, Kontrollschild, Kaufdatum,
   Kaufpreis, Kilometerstand, Versicherung und Policennummer.
4. Klicke auf **Roller anlegen**.

---

## Teil 9 – Als App installieren

**iPhone und iPad**

1. `https://ridepilot.ch` in **Safari** öffnen. Chrome funktioniert dafür nicht.
2. Unten auf das **Teilen-Symbol** tippen (Quadrat mit Pfeil nach oben).
3. Nach unten scrollen, **Zum Home-Bildschirm** wählen, oben rechts auf **Hinzufügen**.

**Mac:** Safari, Menü **Ablage** → **Zum Dock hinzufügen**.
**Windows:** Edge oder Chrome, Installieren-Symbol rechts in der Adressleiste.

Beim ersten Start einer Fahrt fragt das Gerät nach dem Standort – tippe auf **Erlauben**.
Auf dem iPhone zusätzlich unter **Einstellungen → Datenschutz & Sicherheit → Ortungsdienste →
Safari-Websites** den **genauen Standort** aktivieren.

---

## Teil 10 – Täglichen Cronjob prüfen

Der Cronjob ist bereits eingerichtet – er steht in `vercel.json` und wurde beim Veröffentlichen
automatisch übernommen.

1. Im Vercel-Projekt oben auf **Settings**, links auf **Cron Jobs**.
2. Dort muss ein Eintrag `/api/cron` mit `0 5 * * *` stehen.
3. Klicke auf **Run** oder **Trigger**, um ihn einmal von Hand zu testen. Es sollte
   `{"ok":true,...}` erscheinen.

Der Gratis-Tarif erlaubt genau einen Lauf pro Tag, ausgelöst irgendwann zwischen 05:00 und 05:59
UTC – im Sommer also zwischen 07:00 und 08:00 Schweizer Zeit. Das reicht für Erinnerungen völlig.

---

## Teil 11 – Abnahme

- [ ] `https://ridepilot.ch` öffnet sich mit Schloss-Symbol
- [ ] Anmeldung funktioniert
- [ ] Fahrzeugprofil ist nach dem Neuladen noch da
- [ ] **Fahrt starten** → Standort wird abgefragt → Geschwindigkeit erscheint
- [ ] **Fahrt beenden** → die Fahrt steht im Fahrtenbuch
- [ ] Fahrtdetail zeigt die Strecke als Linie
- [ ] Batteriestand speichern funktioniert
- [ ] Ein Foto hochladen und wieder öffnen funktioniert
- [ ] Der Speicherbalken bei Dokumenten zeigt eine Zahl
- [ ] **Datenexport** → ZIP wird geladen und lässt sich öffnen
- [ ] **Fahrtenbericht PDF** wird geladen
- [ ] App liegt auf dem Home-Bildschirm und startet ohne Browserleiste
- [ ] Flugmodus einschalten, App öffnen → die Offline-Seite erscheint

---

## Wenn etwas nicht klappt

**Build bricht ab mit `Environment variable not found: DATABASE_URL`**
Die Variable fehlt oder ist falsch geschrieben. Settings → **Environment Variables** prüfen,
danach unter **Deployments** beim obersten Eintrag auf die drei Punkte und **Redeploy**.

**Build bricht ab mit `Can't reach database server` oder `P1001`**
Die Neon-Adresse stimmt nicht oder `?sslmode=require` fehlt am Ende. Beide Werte in Neon
noch einmal kopieren.

**Build bricht ab bei `prisma db push`**
Meist steht in `DIRECT_URL` versehentlich die Adresse **mit** `-pooler`. Prisma braucht dort
die Variante ohne.

**Die erste Seite braucht ein paar Sekunden**
Normal. Neon schaltet die Datenbank nach fünf Minuten ohne Anfrage ab und wieder ein. Das dauert
ein bis zwei Sekunden und kostet nichts.

**`Die Datei ist zu gross`**
Vercel nimmt höchstens 4 MB entgegen. Fotos verkleinert die App selbst; ein sehr grosses PDF
musst du vorher am Mac über **Vorschau → Exportieren → Quartz-Filter: Reduce File Size**
verkleinern.

**`Der Speicher für Dokumente ist fast voll`**
Neon gibt dir 500 MB, RidePilot bremst bei 250 MB. Lade den Datenexport herunter, dann lösch
ältere Dokumente in der App.

**Standort funktioniert nicht**
Prüfe, dass die Adresse mit `https://` beginnt. Ohne HTTPS gibt kein Browser den Standort frei.

**`Zum Home-Bildschirm` fehlt**
Du bist nicht in Safari. Auf iPhone und iPad geht die Installation nur dort.

---

## Wenn du RidePilot später aktualisierst

1. Im GitHub-Repository auf **Add file** → **Upload files** klicken und die geänderten Dateien
   hineinziehen, dann **Commit changes**.
2. Vercel merkt die Änderung selbst und veröffentlicht neu. Du musst nichts weiter tun.

Deine Daten bleiben erhalten – sie liegen bei Neon, nicht im Code.

---

## Sicherung

Die wichtigste Sicherung machst du in der App selbst: **Datenexport → Alle Daten als ZIP laden.**
Darin sind alle Fahrten, Wartungen, Schäden, Kontakte **und** die Originaldateien. Einmal im
Monat, zehn Sekunden. Leg das ZIP in deine iCloud.

Neon bietet im Gratis-Tarif zusätzlich eine Wiederherstellung der letzten sechs Stunden.
Das ersetzt das ZIP nicht – es ist nur ein Notnagel bei einem Fehler von heute Morgen.

---

## Wenn du später doch wechseln willst

Derselbe Code läuft ohne Änderung auf einem Infomaniak-Hosting oder einem eigenen Rechner.
Nötig sind dann nur zwei Handgriffe: in `prisma/schema.prisma` steht wieder
`provider = "mysql"` statt `postgresql`, und die Zeile `directUrl` fällt weg.
Die Anleitung dafür ist [INSTALLATION.md](INSTALLATION.md).
