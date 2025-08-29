//
//  OrderDTO.swift
//  CoffeDaily
//
//  Денормализованный заказ пользователя
//

import Foundation
import FirebaseFirestore

struct OrderItemDTO: Codable {
    var itemId: String        // UUID String
    var title: String         // зафиксированное имя на момент покупки
    var imageName: String
    var size: String
    var qty: Int
    var unitPrice: Double     // зафиксированная цена на момент покупки
}

struct OrderDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var date: Date
    var items: [OrderItemDTO]
    var total: Double
    var idempotencyKey: String
}
