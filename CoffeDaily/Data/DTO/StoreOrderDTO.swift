//
//  StoreOrderDTO.swift
//  CoffeDaily
//
//  Зеркало заказа в очередь магазина
//

import Foundation
import FirebaseFirestore

enum StoreOrderStatus: String, Codable { case created, in_progress, ready, done }

struct StoreOrderLineDTO: Codable {
    var itemId: String
    var title: String
    var size: String
    var qty: Int
    var unitPrice: Double
}

struct StoreOrderDTO: Codable, Identifiable {
    // Используем тот же docID, что и у user-заказа
    @DocumentID var id: String?
    var userId: String
    var date: Date
    var status: StoreOrderStatus
    var lines: [StoreOrderLineDTO]
    var total: Double
}
