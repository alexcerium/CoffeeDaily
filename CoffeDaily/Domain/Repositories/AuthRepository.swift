//
//  AuthRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct AuthUser: Equatable { public let uid: String; public let isAnonymous: Bool; public let email: String? }
public protocol AuthRepository {
    func observe() -> AsyncStream<AuthUser?>
    func signIn(email: String, password: String) async throws
    func register(email: String, password: String) async throws
    func signInAnonymously() async throws
    func linkAnonymousToEmail(email: String, password: String) async throws
    func signOut() async throws
    func currentUID() -> String?
}
