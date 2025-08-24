//
//  CartItemDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

struct CartItemDTO: Codable, Equatable {
    var itemId: UUID
    var size: String
    var qty: Int
}
