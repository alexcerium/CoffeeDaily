//
//  FirebaseUserRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

final class FirebaseUserRepository: UserRepository {
    private let store = FirebaseInMemoryStore.shared

    func currentUser() async throws -> UserProfile {
        UserProfileMapper.toEntity(store.user)
    }

    func saveProfile(_ profile: UserProfile) async throws {
        store.user = UserProfileMapper.toDTO(profile)
    }
}
