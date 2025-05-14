//
//  CoffeeItem.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import Foundation

struct CoffeeItem: Identifiable, Equatable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
    let prices: [String: Double] 
}
