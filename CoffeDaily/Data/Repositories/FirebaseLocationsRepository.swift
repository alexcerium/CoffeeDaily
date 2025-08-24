//
//  FirebaseLocationsRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

final class FirebaseLocationsRepository: LocationsRepository {
    private let store = FirebaseInMemoryStore.shared
    func fetchNearby() async throws -> [CoffeeLocation] {
        store.locations.map(LocationMapper.toEntity(_:))
    }
}
