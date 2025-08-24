//
//  LocationDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// LocationDTO.swift
import Foundation
import FirebaseFirestore

struct LocationDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var latitude: Double
    var longitude: Double
}
