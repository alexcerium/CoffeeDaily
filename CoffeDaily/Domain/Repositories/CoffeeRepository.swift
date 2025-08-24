//
//  CoffeeRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public protocol CoffeeRepository {
    func fetchMenu() async throws -> [CoffeeItem]
}
