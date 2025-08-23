//
//  NotificationsViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation

final class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationItem] = [
        .init(
            title: "−25 % на все фраппе!",
            message: "Сохраните прохладу лета — только сегодня скидка 25 % на все фраппе.",
            date: Date()
        )
    ]
}
