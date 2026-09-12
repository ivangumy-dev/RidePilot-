//
//  DestinationEditorView.swift
//  RidePilot – Navigations-Upgrade
//
//  Neues Ziel anlegen oder die Position eines bestehenden Ziels setzen.
//  Adresse suchen oder aktuellen Standort übernehmen – alles nur lokal.
//

import SwiftUI
import MapKit

struct DestinationEditorView: View {

    let existing: RideDestination?

    @EnvironmentObject private var store: DestinationStore
    @EnvironmentObject private var navigation: RideNavigationModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String = ""
    @State private var symbol: String = "mappin.circle.fill"
    @State private var query: String = ""
    @State private var results: [MKMapItem] = []
    @State private var selected: MKMapItem?
    @State private var isSearching = false

    private let symbols = ["house.fill", "sofa.fill", "person.fill", "bag.fill",
                           "building.2.fill", "fork.knife", "mappin.circle.fill", "star.fill"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("z. B. Zuhause", text: $name)
                }

                Section("Symbol") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(symbols, id: \.self) { item in
                                Image(systemName: item)
                                    .font(.title3)
                                    .frame(width: 44, height: 44)
                                    .background(symbol == item ? Color.accentColor.opacity(0.2) : Color.clear,
                                                in: RoundedRectangle(cornerRadius: 12))
                                    .onTapGesture { symbol = item }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section("Position") {
                    Button {
                        useCurrentLocation()
                    } label: {
                        Label("Aktuellen Standort übernehmen", systemImage: "location.fill")
                    }

                    HStack {
                        TextField("Adresse oder Ort suchen", text: $query)
                        Button("Suchen") { search() }
                            .disabled(query.trimmingCharacters(in: .whitespaces).isEmpty)
                    }

                    if isSearching { ProgressView() }

                    ForEach(results, id: \.self) { item in
                        Button {
                            selected = item
                            if name.isEmpty { name = item.name ?? "" }
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name ?? "Ort").font(.body)
                                    Text(addressText(item)).font(.caption).foregroundStyle(.secondary)
                                }
                                Spacer()
                                if selected == item {
                                    Image(systemName: "checkmark").foregroundStyle(.tint)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    if let selected {
                        Label(selected.name ?? "Position gewählt", systemImage: "mappin.and.ellipse")
                            .foregroundStyle(.green)
                    }
                }
            }
            .navigationTitle(existing == nil ? "Neues Ziel" : "Position setzen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Sichern") { saveAndClose() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty || selected == nil)
                }
            }
            .onAppear {
                if let existing {
                    name = existing.name
                    symbol = existing.symbol
                }
            }
        }
    }

    // MARK: - Aktionen

    private func useCurrentLocation() {
        guard let location = navigation.currentLocation else { return }
        let placemark = MKPlacemark(coordinate: location.coordinate)
        let item = MKMapItem(placemark: placemark)
        item.name = name.isEmpty ? "Aktueller Standort" : name
        selected = item
    }

    private func search() {
        isSearching = true
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        if let location = navigation.currentLocation {
            request.region = MKCoordinateRegion(center: location.coordinate,
                                                latitudinalMeters: 50_000,
                                                longitudinalMeters: 50_000)
        }
        MKLocalSearch(request: request).start { response, _ in
            DispatchQueue.main.async {
                isSearching = false
                results = response?.mapItems ?? []
            }
        }
    }

    private func saveAndClose() {
        guard let selected else { return }
        let coordinate = selected.placemark.coordinate
        let address = addressText(selected)

        if let existing {
            var updated = existing
            updated.name = name
            updated.symbol = symbol
            updated.setCoordinate(coordinate, address: address)
            store.update(updated)
        } else {
            store.add(RideDestination(name: name,
                                      symbol: symbol,
                                      latitude: coordinate.latitude,
                                      longitude: coordinate.longitude,
                                      address: address))
        }
        dismiss()
    }

    private func addressText(_ item: MKMapItem) -> String {
        let placemark = item.placemark
        return [placemark.thoroughfare, placemark.subThoroughfare, placemark.postalCode, placemark.locality]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}
