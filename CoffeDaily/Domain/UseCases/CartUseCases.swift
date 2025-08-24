//
//  CartUseCases.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct GetCartUseCase {
    let repo: CartRepository
    public init(repo: CartRepository) { self.repo = repo }
    public func execute() async throws -> [CartItem] { try await repo.getItems() }
}

public struct AddToCartUseCase {
    let repo: CartRepository
    public init(repo: CartRepository) { self.repo = repo }
    public func execute(itemId: UUID, size: String, qty: Int) async throws { try await repo.add(itemId: itemId, size: size, qty: qty) }
}

public struct UpdateCartItemUseCase {
    let repo: CartRepository
    public init(repo: CartRepository) { self.repo = repo }
    public func execute(itemId: UUID, size: String, qty: Int) async throws { try await repo.update(itemId: itemId, size: size, qty: qty) }
}

public struct RemoveFromCartUseCase {
    let repo: CartRepository
    public init(repo: CartRepository) { self.repo = repo }
    public func execute(itemId: UUID, size: String) async throws { try await repo.remove(itemId: itemId, size: size) }
}

public struct ClearCartUseCase {
    let repo: CartRepository
    public init(repo: CartRepository) { self.repo = repo }
    public func execute() async throws { try await repo.clear() }
}

public struct ObserveCartTotalsUseCase {
    let repo: CartRepository
    public init(repo: CartRepository) { self.repo = repo }
    public func stream() -> AsyncStream<CartTotals> { repo.observeTotals() }
}
