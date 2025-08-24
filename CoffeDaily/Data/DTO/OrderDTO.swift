//
//  OrderDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// OrderDTO.swift
import Foundation
import FirebaseFirestore

struct OrderDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var date: Date
    var items: [CartItemDTO]
}
