//
//  LocationDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation
import CoreLocation

struct LocationDTO: Codable, Identifiable {
    var id: UUID
    var latitude: Double
    var longitude: Double
}
