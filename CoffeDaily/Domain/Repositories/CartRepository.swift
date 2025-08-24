//
//  CartRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct CartTotals: Equatable { public let items: Int; public let cost: Double }

public protocol CartRepository {
    func getItems() async throws -> [CartItem]
    func add(itemId: UUID, size: String, qty: Int) async throws
    func update(itemId: UUID, size: String, qty: Int) async throws
    func remove(itemId: UUID, size: String) async throws
    func clear() async throws
    func observeTotals() -> AsyncStream<CartTotals>
}
