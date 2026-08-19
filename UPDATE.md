# Update: Struktur, Schnellzugriff, Code-Sperre, Karte

Aufbauend auf dem, was schon läuft. Deine Daten bleiben unverändert.

---

## 1. Aufgeräumt

Vorher lagen alle 21 Seiten gleichrangig nebeneinander. Jetzt gibt es unten **fünf Reiter**,
alles andere hängt darunter:

| Reiter | Was drin ist |
|---|---|
| **Start** | Fahrt starten, Schnellzugriff, was gerade wichtig ist, Monatszahlen |
| **Fahren** | Der Fahrtmodus |
| **Verlauf** | Fahrtenbuch und Berichte |
| **Roller** | Batterie, Service, Schäden, Fahrzeugprofil, Dokumente – mit Statusanzeige |
| **Mehr** | Sicherheit, Ausrüstung, Einstellungen, Sicherung, Datenschutz |

Der Reiter **Roller** ist neu und zeigt auf einen Blick, was ansteht: Ladestand, nächster
Service, offene Schäden, ablaufende Versicherung. Kein Durchklicken mehr, um das zu sehen.

Die Startseite ist deutlich kürzer. Weggefallen sind die doppelten Knopfreihen und der
Dauerhinweis zum Wetter – der stand jeden Tag da und sagte jeden Tag dasselbe.

---

## 2. Schnellzugriff: eigene Tasten

Bis zu **sechs frei belegbare Tasten** auf Start und im Fahrtmodus, dazu Foto und Nachricht.

Fertige Vorlagen zum Antippen: Spotify, Apple Music, JBL Flip 5, UE Boom, Lautstärke, Karten.
Eigene Tasten gehen auch – Beschriftung und Link eingeben, fertig.

**Einstellungen → Schnellzugriff**

### JBL, UE Boom und Lautstärke brauchen einen Kurzbefehl

Ehrlich gesagt: Ein Browser darf die JBL-App nicht direkt öffnen und die Lautstärke nicht
verstellen. Der Umweg über die Kurzbefehle-App dauert eine Minute und funktioniert danach
mit einem Tipp. Die Anleitung dafür steht jetzt in der App unter **Mehr → Audio und
Lautsprecher** – fünf Schritte, mit den exakten Namen, die du vergeben musst.

---

## 3. App-Sperre mit Code

Wie bei einer Banking-App: Ist die App eine Weile im Hintergrund gewesen, kommt beim
Zurückkommen das Tastenfeld.

**Einstellungen → App sperren:** nie, 1, 5, 15 oder 60 Minuten.

Zwei Dinge dazu:
- Es braucht einen aktiven Code (**Einstellungen → Anmeldung mit Code**).
- Eine **laufende Fahrt zeichnet trotz Sperre weiter auf**. Die Sperre legt sich nur als
  Schicht darüber, sie hält nichts an.

---

## 4. Karte in der App

Neu kannst du die Strecke auf einer echten Strassenkarte ansehen, statt nach Apple Karten zu
wechseln und wieder zurück.

**Einstellungen → Karte → Karte mit Strassenhintergrund anzeigen**

Der Schalter ist **standardmässig aus**, und zwar mit Absicht: Sobald er an ist, lädt die App
Kartenkacheln von OpenStreetMap, und deren Server sieht dabei, welchen Ausschnitt du
betrachtest. Ohne Schalter zeichnet RidePilot deine Strecke selbst – hübsch genug für den
Überblick, und niemand erfährt davon. Deine Fahrtdaten selbst bleiben in beiden Fällen bei dir.

---

## Was weiterhin nicht geht

Damit du nicht danach suchst:

- **Spotify steuern.** Die Taste öffnet Spotify. Play, Pause, Titelwechsel und Lautstärke
  bleiben bei Spotify, dem Sperrbildschirm oder Siri. Kein Browser darf da hinein.
- **Lautsprecher ein- oder ausschalten.** Weder iOS noch Android erlauben das aus einer
  Web-App. Der Kurzbefehl öffnet die App des Herstellers, mehr nicht.
- **Alles in einem Fenster.** Wenn du Spotify öffnest, wechselt iOS zu Spotify. Die Rückkehr
  geht über die App-Umschaltung oder das kleine Pfeilchen oben links – das ist eine Regel des
  Betriebssystems, keine Entscheidung von RidePilot.

---

## So spielst du es ein

1. Öffne `https://github.com/ivangumy/ridepilot`.
2. **Add file** → **Upload files**.
3. Entpacke die neue `ridepilot.zip`, öffne den Ordner `ridepilot`, markiere alles darin (⌘A)
   und zieh es ins Browserfenster. Wieder: den **Inhalt**, nicht den Ordner.
4. Warte, bis alle Dateien gelistet sind.
5. Beschreibung: `Struktur, Schnellzugriff, Sperre, Karte`
6. **Commit changes**.

Vercel veröffentlicht selbst neu, drei bis sechs Minuten. Dieses Mal kommt ein neues Paket
dazu (die Kartenbibliothek), der Build dauert deshalb etwas länger als sonst.

**Danach auf dem Telefon:** Die App einmal ganz schliessen und neu öffnen. Sie bringt eine
neue Zwischenspeicher-Version mit – ohne Neustart siehst du sonst noch die alte Oberfläche.

---

## Danach einrichten

1. **Einstellungen → Schnellzugriff:** Tasten wählen. Fang mit Spotify an, dann leg die
   Kurzbefehle für JBL und UE Boom an.
2. **Einstellungen → App sperren:** 5 Minuten ist ein guter Anfang.
3. **Einstellungen → Karte:** einmal einschalten und ansehen, dann entscheiden.
4. Auf **Roller** tippen und schauen, ob die Statusanzeigen stimmen.

---

## Wenn etwas nicht stimmt

**Die Oberfläche sieht aus wie vorher**
App ganz schliessen (auf dem iPhone hochwischen und wegschieben) und neu öffnen.

**Die neuen Reiter fehlen**
Vercel → dein Projekt → **Deployments**: Der oberste Eintrag muss auf **Ready** stehen.

**Beim Antippen einer Kurzbefehl-Taste meldet iOS „Kurzbefehl nicht gefunden"**
Der Name stimmt nicht exakt. In der Kurzbefehle-App muss er zeichengenau so heissen wie in
der Taste – auch Gross- und Kleinschreibung.

**Die Karte bleibt grau**
Der Schalter ist aus, oder du bist offline. Kartenkacheln lassen sich nicht zwischenspeichern.

**Das Tastenfeld kommt nicht, obwohl die App lange weg war**
Es braucht einen aktiven Code und eine Sperrzeit über 0. Beides unter Einstellungen.
