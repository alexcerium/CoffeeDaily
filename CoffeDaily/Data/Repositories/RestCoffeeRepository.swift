//
//  RestCoffeeRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

final class RestCoffeeRepository: CoffeeRepository {
    private let client: RestClient
    init(client: RestClient) { self.client = client }

    func fetchMenu() async throws -> [CoffeeItem] {
        let dtos = try await client.getMenu()
        return dtos.map(CoffeeMapper.map(_:))
    }
}
