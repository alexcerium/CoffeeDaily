//
//  LocationsRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public protocol LocationsRepository {
    func fetchNearby() async throws -> [CoffeeLocation]
}
