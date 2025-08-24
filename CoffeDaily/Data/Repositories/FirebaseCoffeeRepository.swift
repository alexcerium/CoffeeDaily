//
//  FirebaseCoffeeRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// Data/Repositories/FirebaseCoffeeRepository.swift
import Foundation
import FirebaseFirestore

final class FirebaseCoffeeRepository: CoffeeRepository {
    private let db = Firestore.firestore()

    func fetchMenu() async throws -> [CoffeeItem] {
        let snap = try await db.collection("menu").getDocuments()
        let dtos: [CoffeeDTO] = try snap.documents.compactMap { try $0.data(as: CoffeeDTO.self) }

        let items: [CoffeeItem] = dtos.map { dto in
            let uuid = dto.id.flatMap { UUID(uuidString: $0) } ?? UUID()
            return CoffeeItem(
                id: uuid,
                imageName: dto.imageName,
                title: dto.title,
                description: dto.description,
                prices: dto.prices
            )
        }

        MenuIndex.shared.update(items)
        return items
    }
}
