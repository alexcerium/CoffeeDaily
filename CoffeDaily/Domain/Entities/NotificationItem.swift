//
//  NotificationItem.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct NotificationItem: Identifiable {
    public let id: UUID
    public let title: String
    public let message: String
    public let date: Date
    public init(id: UUID = UUID(), title: String, message: String, date: Date) {
        self.id = id; self.title = title; self.message = message; self.date = date
    }
 }
