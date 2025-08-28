//
//  CartItem.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct CartItem: Identifiable, Equatable {
    public let id: UUID
    public let item: CoffeeItem
    public var size: String
    public var quantity: Int

    public init(item: CoffeeItem, size: String, quantity: Int) {
        self.item = item
        self.size = size
        self.quantity = quantity
        // Stable per (item.id, size)
        self.id = StableID.fromString(item.id.uuidString + "#" + size)
    }

    public static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        lhs.item.id == rhs.item.id && lhs.size == rhs.size
    }
}
