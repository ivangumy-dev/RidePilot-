# RidePilot E-Roller – bereit für den Store

Alles, was ohne Mac machbar war, ist gebaut. Unten steht nur noch, was du selbst tun musst.

---

## Dateien im Repo

| Datei | Zweck |
|---|---|
| `index.html` | die App – Steuerzentrale, Navigation, Fahrten, Wartung, Papiere |
| `manifest.json` | Name, Icon, Farben – für Home-Bildschirm und Play Store |
| `datenschutz.html` | Datenschutzerklärung, wird von beiden Stores verlangt |
| `capacitor.config.json` | Einstellungen für die spätere native Verpackung |
| `sw.js`, `icon-192.png`, `icon-512.png` | bereits vorhanden |

Adresse der Datenschutzerklärung für die Store-Formulare:
`https://ivangumy-dev.github.io/RidePilot-/datenschutz.html`

---

## Store-Texte (fertig zum Kopieren)

**Name:** RidePilot E-Roller
**Untertitel:** Fahrtenbuch, Reichweite, Navigation
**Kategorie:** Reisen (zweitrangig: Navigation)
**Preis:** CHF 2.00
**Bundle-ID:** ch.ridepilot.eroller

**Beschreibung:**

> RidePilot ist die Steuerzentrale für deinen E-Roller.
>
> Navigation: Ziel antippen, Route starten. Die App zeigt Abbiegehinweise, Ankunftszeit und laufend, wie weit dein Akku noch reicht.
>
> Reichweite: Die Restreichweite wird aus deiner letzten Kalibrierung und den tatsächlich per GPS gefahrenen Kilometern berechnet – nicht geschätzt.
>
> Fahrten: Jede Fahrt mit Strecke, Dauer, Durchschnitts- und Spitzentempo, Route auf der Karte und Tempoverlauf. Fotos lassen sich einer Fahrt anhängen.
>
> Wartung: Bremsen, Reifen, Akku, Beleuchtung und Händlerkontrolle mit Intervallen nach Kilometern und Monaten. Die Ampel zeigt, was fällig wird.
>
> Papiere: Fahrzeugausweis, Versicherung, Führerausweis, Helm und Kaufbeleg als Checkliste, dazu die Schweizer Notrufnummern.
>
> Alle Daten bleiben auf deinem Gerät. Kein Konto, keine Anmeldung, keine Werbung.
>
> Hinweis: Vorlagen und Erinnerungen, keine Rechtsauskunft. Bedienung nur im Stillstand.

**Stichwörter:** Roller, E-Roller, Elektroroller, Fahrtenbuch, Reichweite, Wartung, Schweiz

---

## Was du selbst machen musst

1. **Konten**
   - Apple Developer Program (~CHF 99/Jahr) – nur nötig für den App Store
   - Google Play Console (~CHF 22 einmalig)
   - Bei beiden: Bankverbindung und Steuerformular für bezahlte Apps

2. **Screenshots** – je 4 bis 8 Stück
   - iPhone 6,7" und 6,1", Android-Telefon
   - Gut geeignet: Dashboard, Steuerzentrale während der Fahrt, Karte mit Route, Fahrt-Detail mit Tempoverlauf, Wartungsliste
   - Auf dem iPhone: Seitentaste und Lauter gleichzeitig drücken

3. **Verpacken zur App** (braucht Mac oder iPad)
   ```
   npm install @capacitor/cli @capacitor/core
   npx cap init
   npx cap add ios
   npx cap add android
   npx cap sync
   ```
   Danach in Xcode beziehungsweise Android Studio öffnen und hochladen.

4. **Einreichen**
   - Android zuerst – günstiger, schneller, gute Probe
   - iOS danach mit denselben Texten

---

## Vor der Einreichung noch zu ergänzen

- Berechtigungstexte für den Standort (Info.plist beziehungsweise AndroidManifest)
- Icon in 1024×1024 für den App Store
- Angabe im Apple-Formular: App sammelt keine Daten
- Altersfreigabe 4+ beziehungsweise „Jeder"
