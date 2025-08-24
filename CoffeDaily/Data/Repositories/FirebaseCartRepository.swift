//
//  FirebaseCartRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

final class FirebaseCartRepository: CartRepository {
    private let store = FirebaseInMemoryStore.shared
    private let resolve: (UUID) -> CoffeeItem?
    private let priceOf: (CoffeeItem, String) -> Double

    init(resolveItem: @escaping (UUID) -> CoffeeItem?) {
        self.resolve = resolveItem
        self.priceOf = { item, size in item.prices[size] ?? 0.0 }
    }

    func getItems() async throws -> [CartItem] {
        store.cart.compactMap { CartMapper.toEntity($0, resolve: resolve) }
    }

    func add(itemId: UUID, size: String, qty: Int) async throws {
        if let idx = store.cart.firstIndex(where: { $0.itemId == itemId && $0.size == size }) {
            store.cart[idx].qty += qty
        } else {
            store.cart.append(.init(itemId: itemId, size: size, qty: qty))
        }
        notifyTotals()
    }

    func update(itemId: UUID, size: String, qty: Int) async throws {
        if let idx = store.cart.firstIndex(where: { $0.itemId == itemId && $0.size == size }) {
            store.cart[idx].qty = max(1, qty)
            notifyTotals()
        }
    }

    func remove(itemId: UUID, size: String) async throws {
        store.cart.removeAll { $0.itemId == itemId && $0.size == size }
        notifyTotals()
    }

    func clear() async throws {
        store.cart.removeAll()
        notifyTotals()
    }

    func observeTotals() -> AsyncStream<CartTotals> {
        AsyncStream { continuation in
            let obs = FirebaseInMemoryStore.TotalsObserver(continuation)
            store.cartObservers.append(obs)

            continuation.onTermination = { [weak store] _ in
                guard let store = store else { return }
                store.cartObservers.removeAll { $0.id == obs.id }
            }

            // Немедленно отправим текущее состояние
            if let current = currentTotals() {
                continuation.yield(current)
            }
        }
    }

    // MARK: - Helpers

    private func currentTotals() -> CartTotals? {
        let entities = store.cart.compactMap { CartMapper.toEntity($0, resolve: resolve) }
        let itemsCount = entities.reduce(0) { $0 + $1.quantity }
        let cost = entities.reduce(0.0) { acc, line in acc + priceOf(line.item, line.size) * Double(line.quantity) }
        return CartTotals(items: itemsCount, cost: cost)
    }

    private func notifyTotals() {
        guard let totals = currentTotals() else { return }
        for observer in store.cartObservers {
            observer.continuation.yield(totals)
        }
    }
}
