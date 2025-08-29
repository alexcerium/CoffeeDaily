//
//  FirebaseOrdersRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import CryptoKit

final class FirebaseOrdersRepository: OrdersRepository {
    private let db = Firestore.firestore()
    private let uidProvider: () -> String?
    private let resolve: (UUID) -> CoffeeItem?
    private let storeId = "default" // демо-магазин

    init(uidProvider: @escaping () -> String?, resolveItem: @escaping (UUID) -> CoffeeItem?) {
        self.uidProvider = uidProvider
        self.resolve = resolveItem
    }

    private func userOrdersColl() throws -> CollectionReference {
        guard let uid = uidProvider() else { throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]) }
        return db.collection("users").document(uid).collection("orders")
    }

    private func storeQueueColl() -> CollectionReference {
        db.collection("storeOrdersQueue").document(storeId).collection("orders")
    }

    // MARK: - Idempotency

    private func idempotencyKey(for items: [CartItem]) -> String {
        // Стабильный ключ из упорядоченного списка позиций
        let base = items
            .map { "\($0.item.id.uuidString)#\($0.size)#\($0.quantity)" }
            .sorted()
            .joined(separator: "|")
        return StableID.sha256Hex(base)
    }

    // MARK: - OrdersRepository

    @discardableResult
    func place(_ draft: OrderDraft) async throws -> Order {
        let uid = uidProvider() ?? ""
        let key = idempotencyKey(for: draft.items)

        // 0) Проверка идемпотентности
        let coll = try userOrdersColl()
        let existing = try await coll.whereField("idempotencyKey", isEqualTo: key).limit(to: 1).getDocuments()
        if let doc = existing.documents.first {
            let dto = try doc.data(as: OrderDTO.self)  // doc.data(as:) — чтобы @DocumentID заполнился
            if let order = OrderMapper.toEntity(dto, resolve: resolve) { return order }
        }

        // 1) Денормализованные позиции
        let lines: [OrderItemDTO] = draft.items.map { ci in
            OrderItemDTO(
                itemId: ci.item.id.uuidString,
                title: ci.item.title,
                imageName: ci.item.imageName,
                size: ci.size,
                qty: ci.quantity,
                unitPrice: ci.item.prices[ci.size] ?? 0
            )
        }
        let total = lines.reduce(0.0) { $0 + (Double($1.qty) * $1.unitPrice) }

        // 2) Создание user-заказа
        let dto = OrderDTO(id: nil, date: Date(), items: lines, total: total, idempotencyKey: key)
        let ref = try coll.addDocument(from: dto)

        // 3) Прочитать обратно (для @DocumentID) и отдать доменную модель
        let saved = try await ref.getDocument()
        let back = try saved.data(as: OrderDTO.self)
        guard let order = OrderMapper.toEntity(back, resolve: resolve) else { throw NSError(domain: "Orders", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to map order"]) }

        // 4) Зеркало в очередь магазина (демо, не блокирует)
        Task {
            do {
                let mirror = StoreOrderDTO(
                    id: saved.documentID,
                    userId: uid,
                    date: back.date,
                    status: .created,
                    lines: lines.map { StoreOrderLineDTO(itemId: $0.itemId, title: $0.title, size: $0.size, qty: $0.qty, unitPrice: $0.unitPrice) },
                    total: total
                )
                try storeQueueColl().document(saved.documentID).setData(from: mirror, merge: true)
            } catch {
                print("Mirror to store queue failed: \(error)")
            }
        }

        return order
    }

    func fetchHistory() async throws -> [Order] {
        let snap = try await userOrdersColl()
            .order(by: "date", descending: true)
            .getDocuments()
        let dtos: [OrderDTO] = try snap.documents.compactMap { try $0.data(as: OrderDTO.self) } // doc.data(as:) — важно
        return dtos.compactMap { OrderMapper.toEntity($0, resolve: resolve) }
    }

    func reorder(orderDocId: String) async throws -> [CartItem] {
        // Чёткий доступ к документу по id
        let doc = try await userOrdersColl().document(orderDocId).getDocument()
        guard doc.exists else { return [] }
        let dto = try doc.data(as: OrderDTO.self)

        // Поднимаем в корзину по текущему меню (цены обновятся сами)
        let items: [CartItem] = dto.items.map { line in
            let uuid = UUID(uuidString: line.itemId) ?? StableID.fromString(line.itemId)
            if let coffee = resolve(uuid) {
                return CartItem(item: coffee, size: line.size, quantity: line.qty)
            } else {
                // fallback: пустышка, но с корректным id/size/qty
                return CartItem(item: CoffeeItem(id: uuid, imageName: "placeholder", title: line.title, description: "", prices: [:]), size: line.size, quantity: line.qty)
            }
        }
        return items
    }
}
