# RidePilot auf Infomaniak installieren

> **Hinweis:** Diese Anleitung beschreibt den Betrieb auf einem kostenpflichtigen
> Infomaniak-Hosting mit MariaDB. Für den kostenlosen Weg über Vercel und Neon gilt
> stattdessen [VERCEL.md](VERCEL.md).
>
> Der Code ist inzwischen auf PostgreSQL eingestellt. Für Infomaniak setzt du in
> `prisma/schema.prisma` wieder `provider = "mysql"` und löschst die Zeile `directUrl`.

**Schritt für Schritt, Klick für Klick, Fenster für Fenster.**
Für eine Person ohne Programmierkenntnisse geschrieben. Du brauchst kein Terminal.

Geplante Adresse: **https://ridepilot.ch**
(Falls du eine andere Domain nutzt, ersetze `ridepilot.ch` überall durch deine Adresse.)

Zeitbedarf: ungefähr 45 Minuten, davon 10 Minuten Wartezeit.

---

## Bevor du anfängst

Du brauchst:

1. Ein **Infomaniak-Konto** mit einem **Webhosting** (nicht nur eine Domain).
2. Die Datei **`ridepilot.zip`**, die du zusammen mit dieser Anleitung bekommen hast.
3. Die Domain `ridepilot.ch` in deinem Infomaniak-Konto.

Wichtig zu wissen: Die frühere RidePilot-Version war eine reine Webseite ohne Server.
Diese Version hat eine **echte Datenbank** und braucht deshalb ein **Node.js-Hosting**.
Beides kann parallel laufen, solange du unterschiedliche Adressen benutzt.

---

## Teil 1 – Datenbank anlegen

**Fenster: Infomaniak Manager**

1. Öffne `https://manager.infomaniak.com` und melde dich an.
2. Klicke oben links auf das **Menü-Symbol** (die neun Punkte).
3. Klicke auf **Web-Hosting**.
4. Klicke auf den **Namen deines Hostings**.
5. Klicke in der linken Spalte auf **Datenbanken**.
6. Klicke auf den blauen Knopf **Datenbank hinzufügen**.
7. Fülle aus:
   - **Name der Datenbank:** `ridepilot`
   - **Benutzername:** `ridepilot_user`
   - **Passwort:** Klicke auf **Generieren**. Kopiere das Passwort sofort in eine Notiz.
     Du siehst es später nicht mehr.
8. Klicke auf **Bestätigen**.
9. Notiere dir jetzt diese vier Angaben. Du brauchst sie in Teil 4:

   | Angabe | Wo du sie findest |
   |---|---|
   | Servername (Host) | steht in der Datenbankübersicht, oft `xxxxx.myd.infomaniak.com` |
   | Datenbankname | `ridepilot` |
   | Benutzername | `ridepilot_user` |
   | Passwort | dein generiertes Passwort |

---

## Teil 2 – Node.js-Website anlegen

**Fenster: Infomaniak Manager, Bereich Web-Hosting**

1. Gehe zurück zur Übersicht deines Hostings (linke Spalte: **Websites**).
2. Klicke auf den blauen Knopf **Hinzufügen**.
3. Wähle **Ein Projekt mit fortschrittlichen Technologien**. Klicke auf **Weiter**.
4. Wähle **Node.js**.
5. Wähle als Version eine **LTS-Version, mindestens 20**. Klicke auf **Weiter**.
6. Wähle **Ein bereits erworbener Domainname** und trage ein: `ridepilot.ch`
   Klicke auf **Weiter**.
7. Jetzt fragt Infomaniak nach der Methode. Wähle die **eigene Variante**
   (nicht das Beispielprojekt), also die Option mit **eigenem Quellcode**.
8. Klicke auf **Bestätigen**. Die Website wird angelegt – das dauert ein bis zwei Minuten.

---

## Teil 3 – Dateien hochladen

**Fenster: Infomaniak Manager, Bereich Web-Hosting → FTP/SFTP**

Der einfachste Weg ohne Terminal ist der **Dateimanager** im Manager.

1. Klicke in der linken Spalte auf **FTP** und dort auf **Dateimanager**
   (heisst je nach Ansicht auch **Web-FTP** oder **Dateien verwalten**).
2. Öffne den Ordner deiner neuen Website. Er heisst meistens `ridepilot.ch`
   oder `sites/ridepilot.ch`.
3. Der Ordner ist leer oder enthält eine Beispieldatei. **Lösche alles darin.**
4. Klicke auf **Hochladen** und wähle die Datei `ridepilot.zip` von deinem Gerät.
5. Warte, bis der Upload bei 100 % ist.
6. Klicke mit der rechten Maustaste auf `ridepilot.zip` und wähle **Entpacken**
   (oder **Extrahieren**).
7. **Kontrolle:** Nach dem Entpacken müssen diese Dateien direkt im Ordner liegen:
   - `package.json`
   - `next.config.mjs`
   - die Ordner `src`, `prisma`, `public`, `scripts`

   Liegt stattdessen ein Unterordner `ridepilot` darin, öffne ihn, markiere alles
   und verschiebe es eine Ebene höher.
8. Lösche die Datei `ridepilot.zip` – sie wird nicht mehr gebraucht.

> Wenn du lieber ein Programm nutzt: **Cyberduck** oder **FileZilla** funktionieren
> genauso. Die Zugangsdaten für SFTP findest du im Manager unter **FTP**.

---

## Teil 4 – Zugangsdaten eintragen

**Fenster: Dateimanager, im Ordner deiner Website**

1. Suche die Datei `.env.example`.
   Falls du sie nicht siehst: Aktiviere im Dateimanager **Versteckte Dateien anzeigen**.
2. Klicke mit der rechten Maustaste darauf und wähle **Umbenennen**.
3. Neuer Name, genau so, mit Punkt am Anfang und ohne Endung:

   ```
   .env
   ```

4. Öffne die Datei `.env` mit **Bearbeiten**.
5. Ersetze den gesamten Inhalt durch diesen Text. Trage bei `DATABASE_URL`
   deine Werte aus Teil 1 ein:

   ```
   DATABASE_URL="mysql://ridepilot_user:DEIN_DB_PASSWORT@DEIN_DB_SERVER:3306/ridepilot"
   NEXT_PUBLIC_APP_URL="https://ridepilot.ch"
   MAX_UPLOAD_MB=15
   NODE_ENV=production
   ```

   Beispiel, wie es fertig aussieht:

   ```
   DATABASE_URL="mysql://ridepilot_user:9fK2mX7qLp4Z@abcde.myd.infomaniak.com:3306/ridepilot"
   ```

   Achte darauf:
   - Die Anführungszeichen bleiben stehen.
   - Zwischen Passwort und Servername steht ein `@`.
   - Nach dem Servername steht `:3306/ridepilot`.
   - Enthält dein Passwort eines der Zeichen `@ : / # ?`, erzeuge im Manager
     ein neues Passwort ohne diese Zeichen. Das erspart dir Ärger.

6. Klicke auf **Speichern**.

---

## Teil 5 – Node.js-Einstellungen setzen

**Fenster: Infomaniak Manager → Web-Hosting → deine Website**

1. Klicke auf den **Namen deiner Website** (`ridepilot.ch`).
2. Klicke auf **Erweiterte Parameter verwalten**.
3. Klicke auf die Registerkarte **Node.js**.
4. Trage genau diese Werte ein:

   | Feld | Wert zum Kopieren |
   |---|---|
   | **Ausführungsverzeichnis** | `./` |
   | **Build-Befehl** | `npm install && npx prisma generate && npx prisma db push && npm run build` |
   | **Startbefehl** | `npm start` |
   | **Node.js-Version** | die LTS-Version, mindestens 20 |

   Das Feld **Listening Port** lässt du so, wie Infomaniak es vorgibt.
   RidePilot übernimmt den Port automatisch.

5. Klicke auf **Speichern**.

---

## Teil 6 – Erstmals bauen und starten

**Fenster: Dashboard deiner Website**

1. Klicke auf **Build ausführen** (oder **Erstellen**, je nach Ansicht).
2. Ein Protokollfenster öffnet sich. Das dauert **3 bis 8 Minuten**. Lass es offen.
3. Der Build ist erfolgreich, wenn am Ende ungefähr das hier steht:

   ```
   Compiled successfully
   Generating static pages
   ```

4. Klicke danach auf **Starten** (oder **Neustarten**).
5. Der Status muss auf **Läuft** oder **Aktiv** wechseln.

**Wenn der Build rot abbricht:** Öffne das Protokoll und lies die letzte Zeile.
Die häufigsten Ursachen stehen unten unter *Wenn etwas nicht klappt*.

---

## Teil 7 – HTTPS aktivieren

**Fenster: Manager → deine Website**

1. Klicke in der linken Spalte auf **SSL-Zertifikate**.
2. Klicke auf **Kostenloses Zertifikat Let's Encrypt**.
3. Klicke auf **Bestätigen**. Die Ausstellung dauert wenige Minuten.
4. Aktiviere danach **HTTPS-Umleitung** oder **HTTPS erzwingen**.

RidePilot funktioniert **nur** über HTTPS vollständig: Standortzugriff, Installation
als App und der Service Worker verlangen eine gesicherte Verbindung.

---

## Teil 8 – Dein Konto anlegen

**Fenster: Safari oder Chrome auf deinem Telefon**

1. Öffne `https://ridepilot.ch`.
2. Du landest automatisch auf der Seite **Ersteinrichtung**.
3. Trage ein:
   - **Dein Name** – frei wählbar, erscheint in Berichten
   - **E-Mail** – deine Adresse, dient als Benutzername
   - **Passwort** – mindestens 10 Zeichen
4. Klicke auf **Konto anlegen**.
5. Du bist sofort angemeldet und landest beim **Fahrzeugprofil**.

> Diese Seite funktioniert **genau einmal**. Sobald ein Konto existiert, ist sie
> gesperrt und leitet auf die Anmeldung um. Niemand kann sich nachträglich selbst
> ein Konto anlegen.

---

## Teil 9 – Roller erfassen

**Fenster: RidePilot, Seite Fahrzeugprofil**

1. **Name:** `Volta VSX`
2. **Hersteller:** `Volta`, **Modell:** `VSX`
3. **Höchstgeschwindigkeit:** `25`
4. Trage ein, was du zur Hand hast: Baujahr, Seriennummer, Kontrollschild,
   Kaufdatum, Kaufpreis, aktueller Kilometerstand.
5. Trage Versicherung und Policennummer ein, damit die Notfallkarte vollständig ist.
6. Klicke auf **Roller anlegen**.

---

## Teil 10 – Als App installieren

**Auf dem iPhone oder iPad**

1. Öffne `https://ridepilot.ch` in **Safari**. Chrome funktioniert dafür nicht.
2. Tippe unten in der Mitte auf das **Teilen-Symbol** (Quadrat mit Pfeil nach oben).
3. Scrolle nach unten und tippe auf **Zum Home-Bildschirm**.
4. Tippe oben rechts auf **Hinzufügen**.
5. RidePilot liegt jetzt als App-Symbol auf dem Home-Bildschirm und startet ohne Browserleiste.

**Auf dem Mac**

1. Öffne die Seite in Safari.
2. Menü **Ablage**, dann **Zum Dock hinzufügen**.

**Auf Windows**

1. Öffne die Seite in Edge oder Chrome.
2. Klicke rechts in der Adressleiste auf das **Installieren-Symbol** (Bildschirm mit Pfeil).
3. Klicke auf **Installieren**.

---

## Teil 11 – Standort erlauben

Beim ersten Start einer Fahrt fragt dein Gerät nach dem Standort.

1. Tippe auf **Erlauben**.
2. Auf dem iPhone zusätzlich: **Einstellungen** → **Datenschutz & Sicherheit** →
   **Ortungsdienste** → **Safari-Websites** → **Beim Verwenden der App**.
3. Aktiviere dort auch **Genauer Standort**.

Ohne genauen Standort zeichnet RidePilot Strecke und Geschwindigkeit nur grob auf.

---

## Teil 12 – Täglichen Cronjob einrichten

Der Cronjob erzeugt Erinnerungen für Service und Versicherung, räumt abgelaufene
Sitzungen auf und wendet deine Löschfrist an.

**Fenster: Manager → dein Hosting → Cron-Aufgaben**

1. Klicke in der linken Spalte auf **Cron-Aufgaben** (oder **Geplante Aufgaben**).
2. Klicke auf **Aufgabe hinzufügen**.
3. Fülle aus:
   - **Typ:** `Node.js` – falls nicht vorhanden, wähle **Shell** oder **Befehl**
   - **Auszuführender Befehl:**
     ```
     node scripts/cron-notifications.mjs
     ```
   - **Verzeichnis:** der Ordner deiner Website
   - **Häufigkeit:** täglich
   - **Uhrzeit:** `06:00`
4. Klicke auf **Speichern**.

Wenn dein Tarif keine Cron-Aufgaben erlaubt, ist das kein Problem: Alle Angaben sind
trotzdem in der App sichtbar, du bekommst nur keine automatischen Erinnerungen.

---

## Teil 13 – Abnahme: funktioniert alles?

Geh diese Liste einmal durch. Nach jedem Punkt weisst du, dass ein Teil sicher läuft.

- [ ] `https://ridepilot.ch` öffnet sich mit Schloss-Symbol
- [ ] Anmeldung funktioniert
- [ ] Fahrzeugprofil lässt sich speichern und ist nach dem Neuladen noch da
- [ ] **Fahrt starten** → Standort wird abgefragt → Geschwindigkeit erscheint
- [ ] **Fahrt beenden** → die Fahrt steht im Fahrtenbuch
- [ ] Fahrtdetail zeigt die Strecke als Linie
- [ ] Batteriestand speichern funktioniert
- [ ] Ein Dokument hochladen und wieder öffnen funktioniert
- [ ] **Datenexport** → ZIP wird geladen und lässt sich öffnen
- [ ] **Fahrtenbericht PDF** wird geladen
- [ ] App liegt auf dem Home-Bildschirm und startet ohne Browserleiste
- [ ] Flugmodus einschalten, App öffnen → die Offline-Seite erscheint

---

## Wenn etwas nicht klappt

**Der Build bricht ab mit `Can't reach database server`**
Die Zeile `DATABASE_URL` in der `.env` stimmt nicht. Prüfe Servername, Benutzername
und Passwort. Achte auf das `@` vor dem Servernamen und auf `:3306/ridepilot` danach.

**Der Build bricht ab mit `P1000` oder `Authentication failed`**
Das Datenbankpasswort ist falsch. Erzeuge im Manager unter **Datenbanken** ein neues
Passwort und trage es in die `.env` ein.

**Die Seite zeigt `502` oder `Application error`**
Die Anwendung läuft nicht. Öffne im Dashboard die **Ausführungskonsole** und lies die
letzten Zeilen. Meistens fehlt die `.env` oder sie heisst noch `.env.example`.

**Die Seite bleibt weiss**
Der Build lief noch nicht. Klicke im Dashboard auf **Build ausführen** und danach auf
**Neustarten**.

**Standort funktioniert nicht**
Prüfe, ob die Adresse mit `https://` beginnt. Ohne HTTPS gibt kein Browser den
Standort frei.

**`Zum Home-Bildschirm` fehlt im Teilen-Menü**
Du bist nicht in Safari. Auf iPhone und iPad funktioniert die Installation nur dort.

**Ein Dokument lässt sich nicht hochladen**
Erlaubt sind PDF, JPG, PNG, WEBP, HEIC und TXT bis 4 MB. RidePilot prüft den
tatsächlichen Dateiinhalt, nicht nur die Endung.

---

## Wenn du RidePilot später aktualisierst

1. Neue `ridepilot.zip` in den Website-Ordner hochladen und entpacken.
   Die Datei `.env` und den Ordner `uploads` dabei **nicht** überschreiben.
2. Im Manager auf **Build ausführen** klicken.
3. Danach auf **Neustarten** klicken.

Deine Daten bleiben dabei erhalten, weil sie in der Datenbank liegen und nicht im Code.
