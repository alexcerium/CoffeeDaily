//
//  NotificationsRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public protocol NotificationsRepository {
    func fetchAll() async throws -> [NotificationItem]
}
