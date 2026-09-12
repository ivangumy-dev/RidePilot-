//
//  RideDestination.swift
//  RidePilot – Navigations-Upgrade
//
//  Datenmodell für ein gespeichertes Ziel.
//  Koordinaten sind optional: Namen dürfen im Repository stehen,
//  die tatsächlichen (privaten) Adressen werden nur lokal auf dem
//  iPhone gespeichert.
//

import Foundation
import CoreLocation

struct RideDestination: Identifiable, Codable, Hashable {

    var id: UUID
    var name: String
    var symbol: String
    var latitude: Double?
    var longitude: Double?
    var address: String?

    init(id: UUID = UUID(),
         name: String,
         symbol: String = "mappin.circle.fill",
         latitude: Double? = nil,
         longitude: Double? = nil,
         address: String? = nil) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }

    /// Koordinate des Ziels, sofern hinterlegt.
    var coordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    /// true, sobald eine Position hinterlegt ist und sofort navigiert werden kann.
    var isReady: Bool { coordinate != nil }

    mutating func setCoordinate(_ coordinate: CLLocationCoordinate2D, address: String? = nil) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        if let address { self.address = address }
    }
}
