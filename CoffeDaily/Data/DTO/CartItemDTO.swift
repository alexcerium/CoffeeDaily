//
//  CartItemDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// CartItemDTO.swift
import Foundation
import FirebaseFirestore

struct CartItemDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var itemId: String      // UUID(uuidString:) on read; .uuidString on write
    var size: String
    var qty: Int
}
