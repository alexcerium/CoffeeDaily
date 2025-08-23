//
//  MenuViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import Foundation

final class CoffeeMenuViewModel: ObservableObject {
    @Published var menu: [CoffeeItem] = [
        .init(
            imageName: "latte",
            title: "Латте",
            description: "Классический латте на молоке",
            prices: ["S": 3.0, "M": 3.5, "L": 4.0]
        ),
        .init(
            imageName: "cappuccino",
            title: "Капучино",
            description: "Воздушная молочная пенка и насыщенный вкус",
            prices: ["S": 2.8, "M": 3.0, "L": 3.4]
        ),
        .init(
            imageName: "americano",
            title: "Американо",
            description: "Чёрный кофе, насыщенный и крепкий",
            prices: ["S": 2.0, "M": 2.5, "L": 2.8]
        ),
        .init(
            imageName: "flatwhite",
            title: "Флэт уайт",
            description: "Идеальный баланс эспрессо и молока",
            prices: ["S": 3.5, "M": 3.8, "L": 4.2]
        ),
        .init(
            imageName: "espresso",
            title: "Эспрессо",
            description: "Быстрый, крепкий, бодрящий",
            prices: ["S": 1.8, "M": 2.0, "L": 2.3]
        ),
        .init(
            imageName: "mocha",
            title: "Мокка",
            description: "Шоколадный латте с эспрессо",
            prices: ["S": 3.5, "M": 4.0, "L": 4.5]
        ),
        .init(
            imageName: "macchiato",
            title: "Макиато",
            description: "Капля молока в чистом эспрессо",
            prices: ["S": 2.5, "M": 2.7, "L": 3.0]
        ),
        .init(
            imageName: "raf",
            title: "Раф",
            description: "Сливочный кофейный напиток",
            prices: ["S": 4.0, "M": 4.2, "L": 4.6]
        ),
        .init(
            imageName: "icecoffee",
            title: "Айс Кофе",
            description: "Охлаждённый кофе со льдом",
            prices: ["S": 2.8, "M": 3.3, "L": 3.7]
        ),
        .init(
            imageName: "frappe",
            title: "Фраппе",
            description: "Взбитый кофе с молоком и льдом",
            prices: ["S": 3.5, "M": 3.9, "L": 4.2]
        )
    ]
}
