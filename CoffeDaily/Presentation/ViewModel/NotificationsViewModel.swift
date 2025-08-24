//
//  NotificationsViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation

final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = []
    private let fetch: FetchNotificationsUseCase
    init(fetch: FetchNotificationsUseCase) { self.fetch = fetch }
    @MainActor func load() async { if let list = try? await fetch.execute() { self.notifications = list } }
}
