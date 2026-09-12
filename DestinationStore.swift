//
//  DestinationStore.swift
//  RidePilot – Navigations-Upgrade
//
//  Speichert die Ziele als JSON im App-Support-Ordner des Geräts.
//  Es werden keine Adressen im Quellcode abgelegt.
//

import Foundation
import CoreLocation

final class DestinationStore: ObservableObject {

    @Published private(set) var destinations: [RideDestination] = []

    private let fileURL: URL

    init() {
        let folder = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        self.fileURL = folder.appendingPathComponent("ride_destinations.json")
        load()
    }

    // MARK: - Laden / Sichern

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let saved = try? JSONDecoder().decode([RideDestination].self, from: data),
              !saved.isEmpty else {
            destinations = DestinationStore.starterList
            save()
            return
        }
        destinations = saved
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(destinations) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    /// Nur Namen und Symbole – ohne Koordinaten.
    /// Die Position wird beim ersten Antippen einmalig auf dem Gerät gesetzt.
    private static var starterList: [RideDestination] {
        [
            RideDestination(name: "Zuhause", symbol: "house.fill"),
            RideDestination(name: "Glattzentrum", symbol: "bag.fill"),
            RideDestination(name: "Wohnzimmer", symbol: "sofa.fill"),
            RideDestination(name: "Remo", symbol: "person.fill"),
            RideDestination(name: "Dafi", symbol: "person.fill")
        ]
    }

    // MARK: - Bearbeiten

    func add(_ destination: RideDestination) {
        destinations.append(destination)
        save()
    }

    func update(_ destination: RideDestination) {
        guard let index = destinations.firstIndex(where: { $0.id == destination.id }) else { return }
        destinations[index] = destination
        save()
    }

    func setCoordinate(_ coordinate: CLLocationCoordinate2D,
                       address: String?,
                       for destination: RideDestination) {
        guard let index = destinations.firstIndex(where: { $0.id == destination.id }) else { return }
        destinations[index].setCoordinate(coordinate, address: address)
        save()
    }

    func delete(at offsets: IndexSet) {
        destinations.remove(atOffsets: offsets)
        save()
    }

    func destination(with id: UUID) -> RideDestination? {
        destinations.first { $0.id == id }
    }
}
