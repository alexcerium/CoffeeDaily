//
//  Order.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct Order: Identifiable {
    public let id = UUID()
    public let date: Date
    public let items: [CartItem]
}
