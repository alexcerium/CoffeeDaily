//
//  AppContainer.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

@MainActor
final class AppContainer: ObservableObject {
    // Contracts
    private(set) var coffeeRepository: CoffeeRepository

    // Use cases exposed to Presentation
    private(set) var fetchMenu: FetchMenuUseCase

    init() {
        // Firebase-only wiring (swap FakeFirebaseClient with real SDK client later)
        let client = FakeFirebaseClient()
        let repo = FirebaseCoffeeRepository(client: client)
        self.coffeeRepository = repo
        self.fetchMenu = FetchMenuUseCase(repository: repo)
    }
}
