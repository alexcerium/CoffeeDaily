//
//  AppContainer.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

@MainActor
final class AppContainer: ObservableObject {
    enum DataSource { case rest, firebase }

    // Contracts
    private(set) var coffeeRepository: CoffeeRepository

    // Use cases exposed to Presentation
    private(set) var fetchMenu: FetchMenuUseCase

    @Published private(set) var dataSource: DataSource

    init(dataSource: DataSource = .rest) {
        self.dataSource = dataSource
        // initial wiring
        let repo = AppContainer.makeCoffeeRepository(for: dataSource)
        self.coffeeRepository = repo
        self.fetchMenu = FetchMenuUseCase(repository: repo)
    }

    func switchTo(_ source: DataSource) {
        guard source != dataSource else { return }
        self.dataSource = source
        let repo = AppContainer.makeCoffeeRepository(for: source)
        self.coffeeRepository = repo
        self.fetchMenu = FetchMenuUseCase(repository: repo)
    }

    private static func makeCoffeeRepository(for source: DataSource) -> CoffeeRepository {
        switch source {
        case .rest:
            // Swap clients when you connect real networking
            let client = FakeRestClient()
            return RestCoffeeRepository(client: client)
        case .firebase:
            let client = FakeFirebaseClient()
            return FirebaseCoffeeRepository(client: client)
        }
    }
}
