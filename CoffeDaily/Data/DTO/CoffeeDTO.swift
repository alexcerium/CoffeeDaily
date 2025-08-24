//
//  CoffeeDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// CoffeeDTO.swift
import Foundation
import FirebaseFirestore

struct CoffeeDTO: Codable, Identifiable {
    @DocumentID var id: String?
    let imageName: String
    let title: String
    let description: String
    let prices: [String: Double]
}
