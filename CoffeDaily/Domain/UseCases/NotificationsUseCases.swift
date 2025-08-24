//
//  NotificationsUseCases.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct FetchNotificationsUseCase {
    let repo: NotificationsRepository
    public init(repo: NotificationsRepository) { self.repo = repo }
    public func execute() async throws -> [NotificationItem] { try await repo.fetchAll() }
}
