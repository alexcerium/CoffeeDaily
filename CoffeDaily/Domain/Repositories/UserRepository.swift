//
//  UserRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public protocol UserRepository {
    func currentUser() async throws -> UserProfile
    func saveProfile(_ profile: UserProfile) async throws
}
