//
//  OrderDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

struct OrderDTO: Codable, Identifiable {
    var id: UUID
    var date: Date
    var items: [CartItemDTO]
}
