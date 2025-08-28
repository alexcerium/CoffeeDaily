//
//  FirebaseCoffeeRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation
import FirebaseFirestore

final class FirebaseCoffeeRepository: CoffeeRepository {
    private let db = Firestore.firestore()

    func fetchMenu() async throws -> [CoffeeItem] {
        let snap = try await db.collection("menu").getDocuments()
        let dtos: [CoffeeDTO] = try snap.documents.compactMap { try $0.data(as: CoffeeDTO.self) }
        let items = dtos.map(CoffeeMapper.map(_:))
        MenuIndex.shared.update(items) // single place
        return items
    }
}
