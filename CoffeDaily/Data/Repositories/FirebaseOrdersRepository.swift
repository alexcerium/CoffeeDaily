//
//  FirebaseOrdersRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// Data/Repositories/FirebaseOrdersRepository.swift
import FirebaseAuth
import FirebaseFirestore

final class FirebaseOrdersRepository: OrdersRepository {
    private let db = Firestore.firestore()
    private let uidProvider: () -> String?
    private let resolve: (UUID) -> CoffeeItem?

    init(uidProvider: @escaping () -> String?, resolveItem: @escaping (UUID) -> CoffeeItem?) {
        self.uidProvider = uidProvider
        self.resolve = resolveItem
    }

    private func coll() throws -> CollectionReference {
        guard let uid = uidProvider() else { throw NSError(domain: "Auth", code: 401) }
        return db.collection("users").document(uid).collection("orders")
    }

    @discardableResult
    func place(_ draft: OrderDraft) async throws -> Order {
        let dto = OrderDTO(id: nil, date: Date(), items: draft.items.map(CartMapper.toDTO(_:)))
        let ref = try coll().addDocument(from: dto)
        let saved = try await ref.getDocument()
        let back = try saved.data(as: OrderDTO.self)
        let entities = back.items.compactMap { CartMapper.toEntity($0, resolve: resolve) }
        return Order(date: back.date, items: entities)
    }

    func fetchHistory() async throws -> [Order] {
        let snap = try await coll().order(by: "date", descending: true).getDocuments()
        let dtos = try snap.documents.compactMap { try $0.data(as: OrderDTO.self) }
        return dtos.compactMap { OrderMapper.toEntity($0, resolve: resolve) }
    }

    func reorder(orderId: UUID) async throws -> [CartItem] {
        let list = try await fetchHistory()
        return list.first?.items ?? []
    }
}
