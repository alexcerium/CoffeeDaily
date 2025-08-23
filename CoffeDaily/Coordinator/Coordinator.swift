//
//  Coordinator.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import SwiftUI

enum Route: Hashable {
    case home
    case menu
    case orders
    case cart
    case payment
    case profile
    case notifications
}

final class AppCoordinator: ObservableObject {
    @Published var path: [Route] = []

    @ViewBuilder
    func start() -> some View {
        CoffeeHomeView()
    }

    func navigate(to route: Route) {
        path.append(route)
    }

    func pop() {
        
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
