//
//  CoffeeLocation.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation
import CoreLocation

public struct CoffeeLocation: Identifiable {
    public let id = UUID()
    public let coordinate: CLLocationCoordinate2D
}
