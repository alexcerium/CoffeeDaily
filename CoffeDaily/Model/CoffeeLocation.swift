//
//  CoffeeLocation.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import Foundation
import CoreLocation

struct CoffeeLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
