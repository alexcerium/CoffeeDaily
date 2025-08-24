//
//  SessionViewModel.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

@MainActor
final class SessionViewModel: ObservableObject {
    enum State { case loading, unauthorized, authorized }
    @Published var state: State = .loading

    /// Колбэк для реакции на смену состояния (например, очистка навигации)
    var onStateChanged: ((State) -> Void)?

    private let observeAuth: ObserveAuthUseCase
    private let signOutUC: SignOutUseCase
    private let signInAnonUC: SignInAnonUseCase

    init(observeAuth: ObserveAuthUseCase,
         signInAnon: SignInAnonUseCase,
         signOut: SignOutUseCase) {
        self.observeAuth = observeAuth
        self.signInAnonUC = signInAnon
        self.signOutUC = signOut
        Task { await self.bind() }
    }

    private func bind() async {
        for await user in observeAuth.stream() {
            let newState: State = (user == nil) ? .unauthorized : .authorized
            if state != newState {
                state = newState
                onStateChanged?(newState) // уведомляем AppCoordinator
            }
        }
    }

    func signInAnonymously() {
        Task { try? await signInAnonUC.execute() }
    }

    func signOut() {
        Task { try? await signOutUC.execute() }
    }
}
