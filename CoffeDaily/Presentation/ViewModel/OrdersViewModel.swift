//
//  OrdersViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation

final class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []

    private let place: PlaceOrderUseCase
    private let fetch: FetchOrdersUseCase
    private let reorderUseCase: ReorderUseCase

    init(place: PlaceOrderUseCase, fetch: FetchOrdersUseCase, reorder: ReorderUseCase) {
        self.place = place
        self.fetch = fetch
        self.reorderUseCase = reorder
    }

    @MainActor func load() async {
        if let list = try? await fetch.execute() { self.orders = list }
    }

    @MainActor func placeOrder(from cartItems: [CartItem]) async {
        let draft = OrderDraft(items: cartItems)
        if let order = try? await place.execute(draft) {
            orders.insert(order, at: 0)
        }
    }

    func itemsForReorder(orderId: UUID) async -> [CartItem] {
        (try? await reorderUseCase.execute(orderId: orderId)) ?? []
    }
}
