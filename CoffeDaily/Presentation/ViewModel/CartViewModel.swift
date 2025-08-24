//
//  CartViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation
import SwiftUI

final class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []
    @Published var animateBadge = false
    @Published var totals: CartTotals = .init(items: 0, cost: 0)

    private let getCart: GetCartUseCase
    private let addUseCase: AddToCartUseCase
    private let updateUseCase: UpdateCartItemUseCase
    private let removeUseCase: RemoveFromCartUseCase
    private let clearUseCase: ClearCartUseCase
    private let observeTotalsUseCase: ObserveCartTotalsUseCase

    init(getCart: GetCartUseCase,
         add: AddToCartUseCase,
         update: UpdateCartItemUseCase,
         remove: RemoveFromCartUseCase,
         clear: ClearCartUseCase,
         observeTotals: ObserveCartTotalsUseCase) {
        self.getCart = getCart
        self.addUseCase = add
        self.updateUseCase = update
        self.removeUseCase = remove
        self.clearUseCase = clear
        self.observeTotalsUseCase = observeTotals

        // Стартуем поток тоталов и первичную загрузку
        let stream = observeTotalsUseCase.stream()
        Task { await self.consumeTotals(stream) }
        Task { await self.refresh() }
    }

    func add(_ coffeeItem: CoffeeItem, size: String) {
        Task {
            try? await addUseCase.execute(itemId: coffeeItem.id, size: size, qty: 1)
            await refresh()
            await bumpBadge()
        }
    }

    func update(_ cartItem: CartItem) {
        Task {
            try? await updateUseCase.execute(itemId: cartItem.item.id, size: cartItem.size, qty: cartItem.quantity)
            await refresh()
        }
    }

    func replace(with items: [CartItem]) {
        Task {
            try? await clearUseCase.execute()
            for it in items {
                try? await addUseCase.execute(itemId: it.item.id, size: it.size, qty: it.quantity)
            }
            await refresh()
        }
    }

    func clear() {
        Task { try? await clearUseCase.execute(); await refresh() }
    }

    func remove(_ cartItem: CartItem) {
        Task { try? await removeUseCase.execute(itemId: cartItem.item.id, size: cartItem.size); await refresh() }
    }

    var totalCount: Int { totals.items }

    // MARK: - Private

    @MainActor
    private func refresh() async {
        if let newItems = try? await getCart.execute() { self.items = newItems }
    }

    @MainActor
    private func consumeTotals(_ stream: AsyncStream<CartTotals>) async {
        for await t in stream {
            let old = totals
            totals = t
            if t.items > old.items { await bumpBadge() }
        }
    }

    @MainActor
    private func bumpBadge() async {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { animateBadge = true }
        await MainActor.run {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { self.animateBadge = false }
            }
        }
    }
}
