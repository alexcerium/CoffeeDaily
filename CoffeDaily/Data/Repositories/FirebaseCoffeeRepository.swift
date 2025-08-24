//
//  FirebaseCoffeeRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

final class FirebaseCoffeeRepository: CoffeeRepository {
    private let client: FirebaseClient
    init(client: FirebaseClient) { self.client = client }

    func fetchMenu() async throws -> [CoffeeItem] {
        let docs = try await client.getMenuCollection()
        return docs.map(CoffeeMapper.map(_:))
    }
}
