//
//  RestClient.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

protocol RestClient {
    func getMenu() async throws -> [CoffeeDTO]
}

// Replace with a real URLSession-backed client when you have an API.
struct FakeRestClient: RestClient {
    func getMenu() async throws -> [CoffeeDTO] {
        try await Task.sleep(nanoseconds: 250_000_000)
        return sample
    }

    private var sample: [CoffeeDTO] {[
        .init(id: nil, imageName: "latte", title: "Латте", description: "Классический латте на молоке", prices: ["S":3.0,"M":3.5,"L":4.0]),
        .init(id: nil, imageName: "cappuccino", title: "Капучино", description: "Воздушная молочная пенка и насыщенный вкус", prices: ["S":2.8,"M":3.0,"L":3.4]),
        .init(id: nil, imageName: "americano", title: "Американо", description: "Чёрный кофе, насыщенный и крепкий", prices: ["S":2.0,"M":2.5,"L":2.8]),
        .init(id: nil, imageName: "flatwhite", title: "Флэт уайт", description: "Идеальный баланс эспрессо и молока", prices: ["S":3.5,"M":3.8,"L":4.2]),
        .init(id: nil, imageName: "espresso", title: "Эспрессо", description: "Быстрый, крепкий, бодрящий", prices: ["S":1.8,"M":2.0,"L":2.3])
    ]}
}
