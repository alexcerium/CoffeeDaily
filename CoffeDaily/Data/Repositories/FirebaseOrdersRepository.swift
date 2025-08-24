//
//  FirebaseOrdersRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

final class FirebaseOrdersRepository: OrdersRepository {
    private let store = FirebaseInMemoryStore.shared
    private let resolve: (UUID) -> CoffeeItem?

    init(resolveItem: @escaping (UUID) -> CoffeeItem?) {
        self.resolve = resolveItem
    }

    func place(_ draft: OrderDraft) async throws -> Order {
        let dto = OrderDTO(
            id: UUID(),
            date: Date(),
            items: draft.items.map(CartMapper.toDTO(_:))
        )
        store.orders.insert(dto, at: 0)
        guard let entity = OrderMapper.toEntity(dto, resolve: resolve) else {
            return Order(id: dto.id, date: dto.date, items: [])
        }
        return entity
    }

    func fetchHistory() async throws -> [Order] {
        store.orders.compactMap { OrderMapper.toEntity($0, resolve: resolve) }
    }

    func reorder(orderId: UUID) async throws -> [CartItem] {
        guard let dto = store.orders.first(where: { $0.id == orderId }) else { return [] }
        return dto.items.compactMap { CartMapper.toEntity($0, resolve: resolve) }
    }
}
