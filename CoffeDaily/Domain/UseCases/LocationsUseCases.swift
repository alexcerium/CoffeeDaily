//
//  LocationsUseCases.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct FetchLocationsUseCase {
    let repo: LocationsRepository
    public init(repo: LocationsRepository) { self.repo = repo }
    public func execute() async throws -> [CoffeeLocation] { try await repo.fetchNearby() }
}
