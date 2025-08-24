//
//  FirebaseCartRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// Data/Repositories/FirebaseCartRepository.swift
import FirebaseAuth
import FirebaseFirestore

final class FirebaseCartRepository: CartRepository {
    private let db = Firestore.firestore()
    private let uidProvider: () -> String?
    private let resolve: (UUID) -> CoffeeItem?

    init(uidProvider: @escaping () -> String?, resolveItem: @escaping (UUID) -> CoffeeItem?) {
        self.uidProvider = uidProvider
        self.resolve = resolveItem
    }

    private func itemsColl() throws -> CollectionReference {
        guard let uid = uidProvider() else { throw NSError(domain: "Auth", code: 401) }
        return db.collection("users").document(uid).collection("cart").document("current").collection("items")
    }

    func getItems() async throws -> [CartItem] {
        let snap = try await itemsColl().getDocuments()
        let dtos = try snap.documents.compactMap { try $0.data(as: CartItemDTO.self) }
        return dtos.compactMap { CartMapper.toEntity($0, resolve: resolve) }
    }

    func add(itemId: UUID, size: String, qty: Int) async throws {
        let coll = try itemsColl()
        let q = coll.whereField("itemId", isEqualTo: itemId.uuidString).whereField("size", isEqualTo: size)
        let snap = try await q.getDocuments()
        if let doc = snap.documents.first {
            try await coll.document(doc.documentID).updateData(["qty": FieldValue.increment(Int64(qty))])
        } else {
            let dto = CartItemDTO(id: nil, itemId: itemId.uuidString, size: size, qty: qty)
            _ = try coll.addDocument(from: dto)
        }
    }

    func update(itemId: UUID, size: String, qty: Int) async throws {
        let coll = try itemsColl()
        let snap = try await coll.whereField("itemId", isEqualTo: itemId.uuidString).whereField("size", isEqualTo: size).getDocuments()
        guard let doc = snap.documents.first else { return }
        try await coll.document(doc.documentID).updateData(["qty": max(1, qty)])
    }

    func remove(itemId: UUID, size: String) async throws {
        let coll = try itemsColl()
        let snap = try await coll.whereField("itemId", isEqualTo: itemId.uuidString).whereField("size", isEqualTo: size).getDocuments()
        for d in snap.documents { try await coll.document(d.documentID).delete() }
    }

    func clear() async throws {
        let coll = try itemsColl()
        let snap = try await coll.getDocuments()
        for d in snap.documents { try await coll.document(d.documentID).delete() }
    }

    func observeTotals() -> AsyncStream<CartTotals> {
        AsyncStream { continuation in
            guard let uid = uidProvider() else { continuation.finish(); return }
            let coll = db.collection("users").document(uid).collection("cart").document("current").collection("items")
            let listener = coll.addSnapshotListener { snap, _ in
                guard let docs = snap?.documents else { return }
                let dtos = docs.compactMap { try? $0.data(as: CartItemDTO.self) }
                let entities = dtos.compactMap { CartMapper.toEntity($0, resolve: self.resolve) }
                let count = entities.reduce(0) { $0 + $1.quantity }
                let cost  = entities.reduce(0.0) { $0 + (($1.item.prices[$1.size] ?? 0) * Double($1.quantity)) }
                continuation.yield(.init(items: count, cost: cost))
            }
            continuation.onTermination = { _ in listener.remove() }
        }
    }
}
