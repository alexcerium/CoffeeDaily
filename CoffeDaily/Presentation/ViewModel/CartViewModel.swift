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

    func add(_ coffeeItem: CoffeeItem, size: String) {
        if let idx = items.firstIndex(where: { $0.item.id == coffeeItem.id && $0.size == size }) {
            items[idx].quantity += 1
        } else {
            items.append(CartItem(item: coffeeItem, size: size, quantity: 1))
        }
        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
            animateBadge = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation { self.animateBadge = false }
        }
    }

    func remove(_ cartItem: CartItem) {
        withAnimation {
            items.removeAll { $0 == cartItem }
        }
    }

    var totalCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }
}
