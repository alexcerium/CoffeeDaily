//
//  FetchMenuUseCase.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct FetchMenuUseCase {
    private let repository: CoffeeRepository
    public init(repository: CoffeeRepository) { self.repository = repository }
    public func execute() async throws -> [CoffeeItem] { try await repository.fetchMenu() }
}
