# Datenschutzerklärung (Vorlage für den privaten Eigenbetrieb)

**Hinweis vorab:** Dies ist eine anpassbare Vorlage, keine Rechtsberatung. Es wird nicht
behauptet, dass diese Software oder dieser Text rechtskonform sind. Solange RidePilot rein
privat läuft und niemand ausser dir Zugang hat, greifen die meisten Pflichten des
Schweizer Datenschutzgesetzes (DSG) nicht. Sobald andere Personen Zugang bekommen oder die
App öffentlich angeboten wird, gehören dieser Text und die Verarbeitung juristisch geprüft
und ein Impressum ergänzt.

## 1. Verantwortliche Stelle

Betreiber dieser Installation: **[Name eintragen]**
Kontakt: **[E-Mail eintragen]**

**Wo die Daten liegen.** Diese Installation läuft bei zwei Anbietern:

| Rolle | Anbieter | Ort der Verarbeitung |
|---|---|---|
| Anwendung | Vercel Inc., USA | Rechenzentrum Frankfurt (`fra1`) |
| Datenbank und Dokumente | Neon (Databricks Inc.), USA | Rechenzentrum Frankfurt (`eu-central-1`) |
| Quellcode | GitHub (Microsoft), USA | privates Repository, ohne Daten |

Beide Betreiber sind US-Unternehmen mit europäischer Infrastruktur. Die Daten werden in
Deutschland verarbeitet, ein Zugriff aus den USA lässt sich aber nicht vollständig ausschliessen.
Wer das nicht möchte, betreibt RidePilot auf einem Schweizer Hosting – der Code ist derselbe,
die Anleitung dazu ist INSTALLATION.md.

## 2. Welche Daten verarbeitet werden

**Konto:** Name, E-Mail-Adresse, Passwort als Argon2id-Hash, Zeitpunkt der letzten Anmeldung.

**Fahrzeug:** Hersteller, Modell, Baujahr, Seriennummer, Kontrollschild, Kaufdatum,
Kaufpreis, Kilometerstand, Versicherungsangaben.

**Fahrten:** Beginn, Ende, Dauer, Strecke, Geschwindigkeiten, Pausen, Personenzahl,
GPS-Punkte mit Zeitstempel, freiwillige Notizen.

**Batterie und Service:** erfasste Ladestände, Ladevorgänge, Wartungen, Reparaturen,
Kosten, Werkstätten.

**Schäden:** Beschreibung, Ursache, Ort, Fotos, Fahrbarkeit, Status.

**Dokumente:** hochgeladene Dateien samt Name, Typ, Grösse und Prüfsumme. Die Dateiinhalte
liegen verschlüsselt übertragen in der Datenbank und sind nur nach Anmeldung abrufbar.

**Kontakte:** Name, Telefonnummer und optional E-Mail von Personen, die du selbst einträgst.
Das Adressbuch des Geräts wird nicht ausgelesen.

**Sicherheitsprotokoll:** Anmeldungen und Fehlversuche, Löschungen, Uploads, Exporte,
IP-Adresse und Browserkennung. Ohne Passwörter, ohne Sitzungsschlüssel, ohne Dateiinhalte.

## 3. Wozu

Ausschliesslich zum Betrieb der App: Fahrten aufzeichnen, Wartung im Blick behalten,
Dokumente ablegen, im Notfall die richtigen Angaben zur Hand haben und die Installation
gegen Missbrauch absichern. Kein anderer Zweck, keine Auswertung zu Werbezwecken,
kein Profiling.

## 4. Standortdaten

Standortdaten sind besonders schützenswert und werden entsprechend behandelt:

- Sie entstehen nur während einer laufenden Fahrt oder wenn du den Standort ausdrücklich abrufst.
- Sie bleiben auf deinem eigenen Server.
- Sie werden nie automatisch geteilt.
- Eine Weitergabe erfolgt nur, wenn du eine Nachricht oder einen Kartenlink selbst absendest.
- Eine Freigabe an Vertrauenspersonen verlangt eine ausdrückliche Bestätigung, die mit
  Zeitpunkt protokolliert wird.

## 5. Weitergabe an Dritte

Ausser an die oben genannten Anbieter, die die Anwendung technisch betreiben, findet keine
Weitergabe statt. RidePilot ruft von sich aus keine weiteren Dienste auf: kein Wetter,
keine Kartenkacheln, keine Analyse, keine Werbung. Öffnest du einen Kartenlink, ruft dein
Browser Apple oder OpenStreetMap auf – dann gelten deren Bestimmungen.

## 6. Aufbewahrung

Standardmässig bleiben die Daten, bis du sie löschst. Unter **Einstellungen** lässt sich
eine automatische Löschfrist für Fahrten setzen (6 bis 36 Monate). Sitzungen laufen nach
12 Stunden ab und werden täglich entfernt.

## 7. Deine Rechte

- **Auskunft und Herausgabe:** Unter **Datenexport** bekommst du alle Daten als ZIP,
  maschinenlesbar als JSON und CSV, samt Originaldateien.
- **Berichtigung:** Jeder Eintrag lässt sich in der App ändern.
- **Löschung:** Einzelne Einträge direkt, das gesamte Konto unter **Verwaltung**.
  Die Löschung entfernt auch alle hochgeladenen Dateien vom Server.

## 8. Sicherheit

Verschlüsselte Übertragung per HTTPS, Passwörter mit Argon2id, Sitzungen mit
zufälligen Token, Prüfung jeder Eingabe, Rate Limiting bei der Anmeldung,
Dokumente ausserhalb des öffentlichen Ordners. Details in [SICHERHEIT.md](SICHERHEIT.md).

## 9. Änderungen

Bei Änderungen an Funktionsumfang oder Verarbeitung gehört dieser Text angepasst.

Stand: **[Datum eintragen]**
