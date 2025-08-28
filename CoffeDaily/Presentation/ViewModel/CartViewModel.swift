//
//  CartViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation
import SwiftUI

@MainActor
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

        // Запускаем поток тоталов и первичную загрузку
        let stream = observeTotalsUseCase.stream()
        Task { await self.consumeTotals(stream) }
        Task { await self.reload() }
    }

    // MARK: - Public API

    func add(_ coffeeItem: CoffeeItem, size: String) {
        Task {
            try? await addUseCase.execute(itemId: coffeeItem.id, size: size, qty: 1)
            // Можно обновить список, так как это не в цикле рендера CartView
            await reload()
            await bumpBadge()
        }
    }

    /// Асинхронное обновление позиции в бэкенде БЕЗ немедленного reload().
    /// UI уже отражает изменения через @Binding.
    func updateAsync(_ cartItem: CartItem) async {
        try? await updateUseCase.execute(itemId: cartItem.item.id,
                                         size: cartItem.size,
                                         qty: cartItem.quantity)
        // Преднамеренно без reload() — избегаем публикаций во время рендера.
    }

    /// Вспомогательный синтаксический сахар.
    func update(_ cartItem: CartItem) {
        Task { await updateAsync(cartItem) }
    }

    /// Оптимистичное удаление: сразу правим локальный список, потом синхронизируемся.
    func remove(_ cartItem: CartItem) {
        // Локально убрать из UI
        if let idx = items.firstIndex(where: { $0.id == cartItem.id }) {
            items.remove(at: idx)
        }
        // Бэкенд — асинхронно, без дополнительной публикации
        Task { try? await removeUseCase.execute(itemId: cartItem.item.id, size: cartItem.size) }
    }

    /// Полная замена корзины (повтор заказа): локально заменить и синхронизировать.
    func replace(with newItems: [CartItem]) {
        // Локально сразу показываем новые позиции
        items = newItems
        // Бэкенд: чистим и добавляем без reload(), чтобы не ломать рендер
        Task {
            try? await clearUseCase.execute()
            for it in newItems {
                try? await addUseCase.execute(itemId: it.item.id, size: it.size, qty: it.quantity)
            }
        }
    }

    func clear() async {
        // Локально
        items = []
        // Бэкенд
        try? await clearUseCase.execute()
    }

    /// Явная перезагрузка списка из бэкенда. Вызывать при входе на экран.
    func reload() async {
        if let newItems = try? await getCart.execute() {
            self.items = newItems
        }
    }

    var totalCount: Int { totals.items }

    // MARK: - Private

    private func consumeTotals(_ stream: AsyncStream<CartTotals>) async {
        for await t in stream {
            let old = totals
            totals = t
            if t.items > old.items { await bumpBadge() }
        }
    }

    private func bumpBadge() async {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { animateBadge = true }
        await MainActor.run {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation { self.animateBadge = false }
            }
        }
    }
}
