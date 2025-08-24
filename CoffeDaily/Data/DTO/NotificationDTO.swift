//
//  NotificationDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

struct NotificationDTO: Codable, Identifiable {
    var id: UUID
    var title: String
    var message: String
    var date: Date
}
