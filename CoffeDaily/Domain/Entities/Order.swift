//
//  Order.swift
//  CoffeDaily
//
//  Доменная модель истории заказа (с зафиксированными ценами)
//

import Foundation

public struct OrderLine: Identifiable {
    public let id: String                 // стабильный: "<itemId>#<size>"
    public let itemId: UUID
    public let title: String
    public let imageName: String
    public let size: String
    public let qty: Int
    public let unitPrice: Double

    public init(itemId: UUID, title: String, imageName: String, size: String, qty: Int, unitPrice: Double) {
        self.itemId = itemId
        self.title = title
        self.imageName = imageName
        self.size = size
        self.qty = qty
        self.unitPrice = unitPrice
        self.id = "\(itemId.uuidString)#\(size)"
    }
}

public struct Order: Identifiable {
    public let id: String                 // Firestore docID
    public let date: Date
    public let lines: [OrderLine]
    public let total: Double

    public init(id: String, date: Date, lines: [OrderLine], total: Double) {
        self.id = id
        self.date = date
        self.lines = lines
        self.total = total
    }
}
