//
//  UserUseCases.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct GetCurrentUserUseCase {
    let repo: UserRepository
    public init(repo: UserRepository) { self.repo = repo }
    public func execute() async throws -> UserProfile { try await repo.currentUser() }
}

public struct SaveProfileUseCase {
    let repo: UserRepository
    public init(repo: UserRepository) { self.repo = repo }
    public func execute(_ profile: UserProfile) async throws { try await repo.saveProfile(profile) }
}
