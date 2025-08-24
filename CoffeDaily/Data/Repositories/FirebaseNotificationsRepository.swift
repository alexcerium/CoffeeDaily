//
//  FirebaseNotificationsRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

final class FirebaseNotificationsRepository: NotificationsRepository {
    private let store = FirebaseInMemoryStore.shared
    func fetchAll() async throws -> [NotificationItem] {
        store.notifications.map(NotificationMapper.toEntity(_:))
    }
}
