//
//  WohinSectionView.swift
//  RidePilot – Navigations-Upgrade
//
//  Der Bereich «Wohin?» für den bestehenden RidePilot-Hauptbildschirm.
//  Ziel antippen -> Route wird berechnet -> Navigation startet.
//

import SwiftUI
import CoreLocation

struct WohinSectionView: View {

    @EnvironmentObject private var store: DestinationStore
    @EnvironmentObject private var navigation: RideNavigationModel

    @State private var destinationToSetUp: RideDestination?
    @State private var showNewDestination = false

    private let columns = [GridItem(.flexible(), spacing: 12),
                           GridItem(.flexible(), spacing: 12)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack {
                Text("Wohin?")
                    .font(.title2.bold())
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                    Text("\(navigation.startRangeKm, specifier: "%.1f") km")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(store.destinations) { destination in
                    Button {
                        if destination.isReady {
                            navigation.startRide(to: destination)
                        } else {
                            destinationToSetUp = destination
                        }
                    } label: {
                        destinationTile(destination)
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    showNewDestination = true
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.title2)
                        Text("Neues Ziel")
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity, minHeight: 96)
                    .background(Color.secondary.opacity(0.12), in: RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
            }

            Stepper(value: $navigation.startRangeKm, in: 5...200, step: 0.5) {
                Text("Startreichweite: \(navigation.startRangeKm, specifier: "%.1f") km")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .disabled(navigation.isRiding)
        }
        .padding(.vertical, 4)
        .sheet(item: $destinationToSetUp) { destination in
            DestinationEditorView(existing: destination)
                .environmentObject(store)
                .environmentObject(navigation)
        }
        .sheet(isPresented: $showNewDestination) {
            DestinationEditorView(existing: nil)
                .environmentObject(store)
                .environmentObject(navigation)
        }
        .fullScreenCover(isPresented: Binding(
            get: { navigation.isRiding },
            set: { if !$0 { navigation.endRide() } }
        )) {
            ActiveRideView()
                .environmentObject(navigation)
        }
    }

    private func destinationTile(_ destination: RideDestination) -> some View {
        VStack(spacing: 8) {
            Image(systemName: destination.symbol)
                .font(.title2)
            Text(destination.name)
                .font(.headline)
                .lineLimit(1)
            if !destination.isReady {
                Text("Position setzen")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 96)
        .background(Color.accentColor.opacity(destination.isReady ? 0.15 : 0.06),
                    in: RoundedRectangle(cornerRadius: 18))
    }
}
