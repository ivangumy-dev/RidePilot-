# RidePilot – Navigations-Upgrade

Reines Upgrade. Es wird nichts aus dem bestehenden Projekt gelöscht oder überschrieben –
nur 5 neue Dateien hinzugefügt und 2 Stellen ergänzt.

Mindestanforderung: Xcode 15+, iOS 17+.

---

## Schritt 1 – Dateien einfügen

1. Xcode öffnen, RidePilot-Projekt öffnen.
2. Im linken Navigator auf den Ordner **RidePilot** rechtsklicken.
3. **Add Files to "RidePilot"…** wählen.
4. Den Ordner **Navigation** aus diesem Paket auswählen.
5. Häkchen setzen bei **Copy items if needed**.
6. Unter **Add to targets** muss **RidePilot** angehakt sein.
7. **Add** klicken.

---

## Schritt 2 – Berechtigungen (Info)

1. Links das blaue Projektsymbol **RidePilot** anklicken.
2. Oben Reiter **Info** wählen.
3. Bei **Custom iOS Target Properties** auf **+** klicken und diese drei Einträge anlegen:

| Key | Wert |
|---|---|
| `Privacy - Location When In Use Usage Description` | RidePilot berechnet damit Route, gefahrene Kilometer und Restreichweite. |
| `Privacy - Location Always and When In Use Usage Description` | Damit die Fahrt weiterläuft, während du andere Apps benutzt. |
| `Privacy - Location Always Usage Description` | Damit die Fahrt weiterläuft, während du andere Apps benutzt. |

---

## Schritt 3 – Hintergrund erlauben

1. Reiter **Signing & Capabilities** öffnen.
2. **+ Capability** klicken.
3. **Background Modes** doppelklicken.
4. Häkchen setzen bei **Location updates**.

---

## Schritt 4 – App-Datei ergänzen

In `RidePilotApp.swift` die bestehende Struktur so ergänzen
(Zeilen mit `//NEU` sind die einzigen Änderungen):

```swift
@main
struct RidePilotApp: App {

    @StateObject private var destinationStore = DestinationStore()      //NEU
    @StateObject private var navigation = RideNavigationModel()         //NEU

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(destinationStore)                    //NEU
                .environmentObject(navigation)                          //NEU
        }
    }
}
```

---

## Schritt 5 – «Wohin?» auf dem Hauptbildschirm einbauen

In `ContentView.swift` an der Stelle, wo der Bereich erscheinen soll,
eine einzige Zeile einfügen:

```swift
WohinSectionView()
```

Steht der Hauptbildschirm in einer `ScrollView` oder `VStack`, reicht das aus.
In einer `List` stattdessen so:

```swift
Section {
    WohinSectionView()
}
```

---

## Schritt 6 – Testen

1. iPhone per Kabel anschliessen, oben in Xcode als Ziel wählen.
2. **Play** (▶) drücken.
3. Beim ersten Start: Standortzugriff erlauben → **Beim Verwenden der App**.
4. Ein Ziel antippen → **Position setzen** → Adresse suchen oder aktuellen Standort übernehmen → **Sichern**.
5. Ziel erneut antippen → Route wird berechnet, Fahrt startet.
6. Beim Hinweis auf dauerhaften Zugriff **Immer erlauben** wählen.

---

## Was das Upgrade macht

- Ziel antippen → Route → Navigation startet direkt in RidePilot (keine Karten-App).
- Gefahrene Kilometer kommen aus dem echten GPS-Weg, nicht aus der Zielentfernung.
- Restreichweite = Startreichweite (Standard 42,0 km) minus tatsächlich gefahrene km.
- Umweg → Route wird automatisch neu berechnet.
- Home-Taste oder App-Wechsel: Fahrt läuft weiter, das iPhone wird nicht gesperrt.
  Beim Zurückkehren sind Route, Kilometer und Restreichweite unverändert da.
- Ziele werden nur lokal auf dem iPhone gespeichert. Im Repository stehen
  ausschliesslich Namen wie «Zuhause» oder «Remo» – keine Adressen, keine Koordinaten.

---

## Dateien in diesem Paket

```
Navigation/
├── RideDestination.swift        Datenmodell eines Ziels
├── DestinationStore.swift       lokale Speicherung (JSON auf dem Gerät)
├── RideNavigationModel.swift    GPS, Route, Kilometer, Restreichweite, Hintergrund
├── WohinSectionView.swift       Bereich «Wohin?» für den Hauptbildschirm
├── ActiveRideView.swift         Ansicht während der Fahrt
└── DestinationEditorView.swift  neues Ziel / Position setzen
```
