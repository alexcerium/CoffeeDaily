//
//  FirebaseAuthRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthRepository: AuthRepository {
    func observe() -> AsyncStream<AuthUser?> {
        AsyncStream { continuation in
            let handle = Auth.auth().addStateDidChangeListener { _, user in
                if let u = user {
                    continuation.yield(.init(uid: u.uid, isAnonymous: u.isAnonymous, email: u.email))
                } else {
                    continuation.yield(nil)
                }
            }
            continuation.onTermination = { _ in Auth.auth().removeStateDidChangeListener(handle) }
        }
    }
    func signIn(email: String, password: String) async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
    }
    func register(email: String, password: String) async throws {
        _ = try await Auth.auth().createUser(withEmail: email, password: password)
    }
    func signInAnonymously() async throws {
        _ = try await Auth.auth().signInAnonymously()
    }
    func linkAnonymousToEmail(email: String, password: String) async throws {
        guard let user = Auth.auth().currentUser, user.isAnonymous else { return }
        let cred = EmailAuthProvider.credential(withEmail: email, password: password)
        _ = try await user.link(with: cred)
    }
    func signOut() async throws { try Auth.auth().signOut() }
    func currentUID() -> String? { Auth.auth().currentUser?.uid }
}
