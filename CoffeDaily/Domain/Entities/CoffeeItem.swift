//
//  CoffeeItem.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct CoffeeItem: Identifiable, Equatable {
    public let id: UUID
    public let imageName: String
    public let title: String
    public let description: String
    public let prices: [String: Double]

    public init(id: UUID = UUID(), imageName: String, title: String, description: String, prices: [String: Double]) {
        self.id = id
        self.imageName = imageName
        self.title = title
        self.description = description
        self.prices = prices
    }
}
