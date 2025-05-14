//
//  Order.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation

struct Order: Identifiable {
    let id = UUID()
    let date: Date
    let items: [CartItem]
}
