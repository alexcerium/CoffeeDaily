//
//  FirebaseClient.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

protocol FirebaseClient {
    func getMenuCollection() async throws -> [CoffeeDTO]
}

// Replace with real Firebase SDK calls when you connect Firebase.
struct FakeFirebaseClient: FirebaseClient {
    func getMenuCollection() async throws -> [CoffeeDTO] {
        try await Task.sleep(nanoseconds: 200_000_000)
        return [
            .init(id: nil, imageName: "raf", title: "Раф", description: "Сливочный кофейный напиток", prices: ["S":4.0,"M":4.2,"L":4.6]),
            .init(id: nil, imageName: "mocha", title: "Мокка", description: "Шоколадный латте с эспрессо", prices: ["S":3.5,"M":4.0,"L":4.5]),
            .init(id: nil, imageName: "macchiato", title: "Макиато", description: "Капля молока в чистом эспрессо", prices: ["S":2.5,"M":2.7,"L":3.0]),
            .init(id: nil, imageName: "icecoffee", title: "Айс Кофе", description: "Охлаждённый кофе со льдом", prices: ["S":2.8,"M":3.3,"L":3.7]),
            .init(id: nil, imageName: "frappe", title: "Фраппе", description: "Взбитый кофе с молоком и льдом", prices: ["S":3.5,"M":3.9,"L":4.2])
        ]
    }
}
