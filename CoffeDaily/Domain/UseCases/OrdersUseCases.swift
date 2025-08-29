//
//  OrdersUseCases.swift
//  CoffeDaily
//

import Foundation

public struct PlaceOrderUseCase {
    let repo: OrdersRepository
    public init(repo: OrdersRepository) { self.repo = repo }
    @discardableResult public func execute(_ draft: OrderDraft) async throws -> Order { try await repo.place(draft) }
}

public struct FetchOrdersUseCase {
    let repo: OrdersRepository
    public init(repo: OrdersRepository) { self.repo = repo }
    public func execute() async throws -> [Order] { try await repo.fetchHistory() }
}

public struct ReorderUseCase {
    let repo: OrdersRepository
    public init(repo: OrdersRepository) { self.repo = repo }
    public func execute(orderDocId: String) async throws -> [CartItem] { try await repo.reorder(orderDocId: orderDocId) }
}
