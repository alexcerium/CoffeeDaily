//
//  NotificationItem.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let date: Date
}
