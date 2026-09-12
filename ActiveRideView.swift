//
//  ActiveRideView.swift
//  RidePilot – Navigations-Upgrade
//
//  Karte, Route, aktuelle Position, nächster Hinweis, Kilometer,
//  Restreichweite und «Fahrt beenden».
//  Die Ansicht darf jederzeit verlassen werden – die Fahrt läuft weiter.
//

import SwiftUI
import MapKit

struct ActiveRideView: View {

    @EnvironmentObject private var navigation: RideNavigationModel
    @Environment(\.dismiss) private var dismiss

    @State private var camera: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        VStack(spacing: 0) {
            map
            panel
        }
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Karte

    private var map: some View {
        Map(position: $camera) {
            UserAnnotation()

            if let route = navigation.route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 7)
            }

            if let ride = navigation.activeRide {
                Marker(ride.destinationName, coordinate: ride.destinationCoordinate)
                    .tint(.red)
            }
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        .frame(maxHeight: .infinity)
    }

    // MARK: - Informationsbereich

    private var panel: some View {
        VStack(alignment: .leading, spacing: 14) {

            if !navigation.nextInstruction.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: navigation.hasArrived ? "flag.checkered" : "arrow.turn.up.right")
                        .font(.title3)
                    Text(navigation.nextInstruction)
                        .font(.headline)
                        .lineLimit(2)
                }
            }

            Text("ZIEL")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(navigation.activeRide?.destinationName ?? "—")
                .font(.title.bold())

            HStack(spacing: 0) {
                value("bis Ziel", navigation.remainingToDestinationKm, .primary)
                Divider().frame(height: 44)
                value("gefahren", navigation.drivenKm, .primary)
                Divider().frame(height: 44)
                value("Restreichweite", navigation.remainingRangeKm,
                      navigation.rangeIsCritical ? .red : .green)
            }

            if navigation.rangeIsCritical {
                Label("Restreichweite reicht nicht bis zum Ziel.", systemImage: "exclamationmark.triangle.fill")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Label("Im Hintergrund", systemImage: "arrow.down.right.and.arrow.up.left")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.bordered)

                Button(role: .destructive) {
                    navigation.endRide()
                    dismiss()
                } label: {
                    Label("Fahrt beenden", systemImage: "stop.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .background(.regularMaterial)
    }

    private func value(_ title: String, _ km: Double, _ color: Color) -> some View {
        VStack(spacing: 2) {
            Text("\(km, specifier: "%.1f") km")
                .font(.title3.bold())
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
