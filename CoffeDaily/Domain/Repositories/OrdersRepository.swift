//
//  OrdersRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct OrderDraft { public let items: [CartItem] }

public protocol OrdersRepository {
    @discardableResult
    func place(_ draft: OrderDraft) async throws -> Order
    func fetchHistory() async throws -> [Order]
    func reorder(orderId: UUID) async throws -> [CartItem]
}
