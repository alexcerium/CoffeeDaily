//
//  FirebaseLocationsRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import FirebaseFirestore
import CoreLocation

final class FirebaseLocationsRepository: LocationsRepository {
    private let db = Firestore.firestore()
    func fetchNearby() async throws -> [CoffeeLocation] {
        let snap = try await db.collection("locations").getDocuments()
        let dtos = try snap.documents.compactMap { try $0.data(as: LocationDTO.self) }
        return dtos.map(LocationMapper.toEntity(_:))
    }
}
