//
//  FirebaseInMemoryStore.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

/// Общий in-memory «стор», имитирующий Firebase.
final class FirebaseInMemoryStore {
    static let shared = FirebaseInMemoryStore()
    private init() {}

    // Cart
    var cart: [CartItemDTO] = []

    // Orders
    var orders: [OrderDTO] = []

    // Notifications
    var notifications: [NotificationDTO] = [
        .init(id: UUID(), title: "−25 % на все фраппе!", message: "Сохраните прохладу лета — только сегодня скидка 25 % на все фраппе.", date: Date())
    ]

    // Locations
    var locations: [LocationDTO] = [
        .init(id: UUID(), latitude: 60.1686, longitude: 24.9398),
        .init(id: UUID(), latitude: 60.1625, longitude: 24.9450),
        .init(id: UUID(), latitude: 60.1712, longitude: 24.9230),
        .init(id: UUID(), latitude: 60.1790, longitude: 24.9302)
    ]

    // User
    var user: UserProfileDTO = .init(name: "", email: "")

    // Наблюдатели тоталов корзины
    final class TotalsObserver {
        let id = UUID()
        var continuation: AsyncStream<CartTotals>.Continuation
        init(_ c: AsyncStream<CartTotals>.Continuation) { self.continuation = c }
    }
    var cartObservers: [TotalsObserver] = []
}
