//
//  OrdersRepository.swift
//  CoffeDaily
//

import Foundation

public struct OrderDraft { public let items: [CartItem] }

public protocol OrdersRepository {
    @discardableResult
    func place(_ draft: OrderDraft) async throws -> Order
    func fetchHistory() async throws -> [Order]
    func reorder(orderDocId: String) async throws -> [CartItem]   // строго по документу
}
