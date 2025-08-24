//
//  CoffeeDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

struct CoffeeDTO: Decodable {
    let id: UUID?
    let imageName: String
    let title: String
    let description: String
    let prices: [String: Double]
}
