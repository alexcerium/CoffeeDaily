//
//  AuthUseCases.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct ObserveAuthUseCase { let repo: AuthRepository
    public init(repo: AuthRepository) { self.repo = repo }
    public func stream() -> AsyncStream<AuthUser?> { repo.observe() }
}
public struct SignInEmailUseCase { let repo: AuthRepository
    public init(repo: AuthRepository) { self.repo = repo }
    public func execute(email: String, password: String) async throws { try await repo.signIn(email: email, password: password) }
}
public struct RegisterEmailUseCase { let repo: AuthRepository
    public init(repo: AuthRepository) { self.repo = repo }
    public func execute(email: String, password: String) async throws { try await repo.register(email: email, password: password) }
}
public struct SignInAnonUseCase { let repo: AuthRepository
    public init(repo: AuthRepository) { self.repo = repo }
    public func execute() async throws { try await repo.signInAnonymously() }
}
public struct LinkAnonToEmailUseCase { let repo: AuthRepository
    public init(repo: AuthRepository) { self.repo = repo }
    public func execute(email: String, password: String) async throws { try await repo.linkAnonymousToEmail(email: email, password: password) }
}
public struct SignOutUseCase { let repo: AuthRepository
    public init(repo: AuthRepository) { self.repo = repo }
    public func execute() async throws { try await repo.signOut() }
}
