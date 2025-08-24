//
//  NotificationDTO.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// NotificationDTO.swift
import Foundation
import FirebaseFirestore

struct NotificationDTO: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var message: String
    var date: Date
}
