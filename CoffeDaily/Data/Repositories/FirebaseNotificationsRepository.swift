//
//  FirebaseNotificationsRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// Data/Repositories/FirebaseNotificationsRepository.swift
import FirebaseAuth
import FirebaseFirestore

final class FirebaseNotificationsRepository: NotificationsRepository {
    private let db = Firestore.firestore()
    private let uidProvider: () -> String?
    init(uidProvider: @escaping () -> String?) { self.uidProvider = uidProvider }

    func fetchAll() async throws -> [NotificationItem] {
        let query: Query
        if let uid = uidProvider() { query = db.collection("users").document(uid).collection("notifications") }
        else { query = db.collection("notifications") }

        let snap = try await query.order(by: "date", descending: true).getDocuments()
        let dtos = try snap.documents.compactMap { try $0.data(as: NotificationDTO.self) }
        return dtos.map(NotificationMapper.toEntity(_:))
    }
}
