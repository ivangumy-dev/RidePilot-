//
//  RideNavigationModel.swift
//  RidePilot – Navigations-Upgrade
//
//  Zuständig für:
//  - Routenberechnung innerhalb der App (MKDirections)
//  - tatsächlich gefahrene Kilometer per GPS
//  - Restreichweite (Startreichweite minus gefahrene Strecke)
//  - Neuberechnung bei Umwegen
//  - Weiterlaufen im Hintergrund und Wiederherstellung nach App-Wechsel
//

import Foundation
import CoreLocation
import MapKit

final class RideNavigationModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: - Gespeicherter Fahrtzustand

    struct ActiveRide: Codable {
        var destinationID: UUID
        var destinationName: String
        var destinationLatitude: Double
        var destinationLongitude: Double
        var startRangeKm: Double
        var drivenMeters: Double
        var startedAt: Date

        var destinationCoordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: destinationLatitude, longitude: destinationLongitude)
        }
    }

    // MARK: - Veröffentlichte Werte

    @Published private(set) var activeRide: ActiveRide?
    @Published private(set) var route: MKRoute?
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var remainingToDestinationMeters: Double = 0
    @Published private(set) var nextInstruction: String = ""
    @Published private(set) var isCalculatingRoute = false
    @Published private(set) var hasArrived = false
    @Published var errorMessage: String?

    /// Reichweite des Rollers bei Fahrtbeginn (frei einstellbar, Standard 42,0 km).
    @Published var startRangeKm: Double {
        didSet { UserDefaults.standard.set(startRangeKm, forKey: Keys.startRange) }
    }

    // MARK: - Abgeleitete Werte

    var isRiding: Bool { activeRide != nil }
    var drivenKm: Double { (activeRide?.drivenMeters ?? 0) / 1000 }
    var remainingToDestinationKm: Double { max(0, remainingToDestinationMeters / 1000) }
    var remainingRangeKm: Double { max(0, (activeRide?.startRangeKm ?? startRangeKm) - drivenKm) }

    /// true, wenn die Restreichweite nicht mehr bis zum Ziel reicht.
    var rangeIsCritical: Bool { isRiding && remainingRangeKm < remainingToDestinationKm }

    // MARK: - Intern

    private enum Keys {
        static let activeRide = "ridepilot.navigation.activeRide"
        static let startRange = "ridepilot.navigation.startRangeKm"
    }

    private let manager = CLLocationManager()
    private var lastLocation: CLLocation?
    private var lastRouteUpdate: Date = .distantPast

    private let minimumStepMeters: Double = 5      // GPS-Zittern ignorieren
    private let maximumStepMeters: Double = 500    // GPS-Sprünge ignorieren
    private let offRouteMeters: Double = 70        // ab hier gilt die Route als verlassen
    private let recalculateInterval: TimeInterval = 20
    private let arrivalMeters: Double = 40

    override init() {
        let saved = UserDefaults.standard.double(forKey: Keys.startRange)
        self.startRangeKm = saved > 0 ? saved : 42.0
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.activityType = .automotiveNavigation
        manager.pausesLocationUpdatesAutomatically = false
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        restoreRideIfNeeded()
    }

    // MARK: - Fahrt starten / beenden

    func startRide(to destination: RideDestination) {
        guard let coordinate = destination.coordinate else {
            errorMessage = "Für «\(destination.name)» ist noch keine Position gespeichert."
            return
        }

        hasArrived = false
        activeRide = ActiveRide(destinationID: destination.id,
                                destinationName: destination.name,
                                destinationLatitude: coordinate.latitude,
                                destinationLongitude: coordinate.longitude,
                                startRangeKm: startRangeKm,
                                drivenMeters: 0,
                                startedAt: Date())
        lastLocation = currentLocation
        persistRide()
        enableBackgroundUpdates()
        calculateRoute(force: true)
    }

    func endRide() {
        activeRide = nil
        route = nil
        nextInstruction = ""
        remainingToDestinationMeters = 0
        hasArrived = false
        lastLocation = nil
        UserDefaults.standard.removeObject(forKey: Keys.activeRide)
        manager.allowsBackgroundLocationUpdates = false
    }

    // MARK: - Wiederherstellung nach App-Wechsel

    private func restoreRideIfNeeded() {
        guard let data = UserDefaults.standard.data(forKey: Keys.activeRide),
              let ride = try? JSONDecoder().decode(ActiveRide.self, from: data) else { return }
        activeRide = ride
        enableBackgroundUpdates()
        calculateRoute(force: true)
    }

    private func persistRide() {
        guard let activeRide, let data = try? JSONEncoder().encode(activeRide) else { return }
        UserDefaults.standard.set(data, forKey: Keys.activeRide)
    }

    private func enableBackgroundUpdates() {
        manager.requestAlwaysAuthorization()
        if manager.authorizationStatus == .authorizedAlways
            || manager.authorizationStatus == .authorizedWhenInUse {
            manager.allowsBackgroundLocationUpdates = true
            manager.showsBackgroundLocationIndicator = true
        }
        manager.startUpdatingLocation()
    }

    // MARK: - Route

    func calculateRoute(force: Bool = false) {
        guard let activeRide, let from = currentLocation else { return }
        if !force, Date().timeIntervalSince(lastRouteUpdate) < recalculateInterval { return }

        lastRouteUpdate = Date()
        isCalculatingRoute = true

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: activeRide.destinationCoordinate))
        request.transportType = .automobile
        request.requestsAlternateRoutes = false

        MKDirections(request: request).calculate { [weak self] response, error in
            DispatchQueue.main.async {
                guard let self else { return }
                self.isCalculatingRoute = false
                if let newRoute = response?.routes.first {
                    self.route = newRoute
                    self.remainingToDestinationMeters = newRoute.distance
                    self.updateInstruction()
                } else if let error {
                    self.errorMessage = "Route konnte nicht berechnet werden: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: - Standortverarbeitung

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last,
              location.horizontalAccuracy > 0,
              location.horizontalAccuracy <= 30 else { return }

        currentLocation = location

        guard activeRide != nil else {
            lastLocation = location
            return
        }

        // 1. tatsächlich gefahrene Strecke aufsummieren
        if let previous = lastLocation {
            let step = location.distance(from: previous)
            if step >= minimumStepMeters && step <= maximumStepMeters {
                activeRide?.drivenMeters += step
                remainingToDestinationMeters = max(0, remainingToDestinationMeters - step)
                persistRide()
            }
        }
        lastLocation = location

        // 2. Ankunft prüfen
        if remainingToDestinationMeters <= arrivalMeters {
            hasArrived = true
            nextInstruction = "Ziel erreicht"
            return
        }

        // 3. Umweg erkennen oder turnusmässig neu berechnen
        if distanceFromRoute(location) > offRouteMeters {
            calculateRoute(force: true)
        } else {
            calculateRoute()
            updateInstruction()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if activeRide != nil { enableBackgroundUpdates() }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Standort nicht verfügbar: \(error.localizedDescription)"
    }

    // MARK: - Hilfsfunktionen

    /// Kleinster Abstand der aktuellen Position zur berechneten Route.
    private func distanceFromRoute(_ location: CLLocation) -> Double {
        guard let polyline = route?.polyline, polyline.pointCount > 0 else { return 0 }
        let points = polyline.points()
        var minimum = Double.greatestFiniteMagnitude
        for index in 0..<polyline.pointCount {
            let coordinate = points[index].coordinate
            let point = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            minimum = min(minimum, location.distance(from: point))
        }
        return minimum
    }

    /// Nächster Navigationshinweis aus den Routenschritten.
    private func updateInstruction() {
        guard let route, let location = currentLocation else { return }

        var bestIndex = 0
        var bestDistance = Double.greatestFiniteMagnitude

        for (index, step) in route.steps.enumerated() {
            let polyline = step.polyline
            guard polyline.pointCount > 0 else { continue }
            let points = polyline.points()
            for pointIndex in 0..<polyline.pointCount {
                let coordinate = points[pointIndex].coordinate
                let point = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let distance = location.distance(from: point)
                if distance < bestDistance {
                    bestDistance = distance
                    bestIndex = index
                }
            }
        }

        for index in bestIndex..<route.steps.count {
            let text = route.steps[index].instructions
            if !text.isEmpty {
                nextInstruction = text
                return
            }
        }
        nextInstruction = "Der Route folgen"
    }
}
