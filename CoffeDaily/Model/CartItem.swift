//
//  CartItem.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation

struct CartItem: Identifiable, Equatable {
    let id = UUID()
    let item: CoffeeItem
    var size: String
    var quantity: Int

    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        lhs.item.id == rhs.item.id && lhs.size == rhs.size
    }
}
