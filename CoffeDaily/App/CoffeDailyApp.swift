//
//  CoffeDailyApp.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

//
//  CoffeDailyApp.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

import SwiftUI

@main
struct CoffeeDailyApp: App {
    @StateObject private var coordinator = AppCoordinator()
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var ordersViewModel = OrdersViewModel()
    @StateObject private var notificationsViewModel = NotificationsViewModel()
    @StateObject private var container = AppContainer() // Firebase-only

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                CoffeeHomeView()
            }
            // Inject app-wide dependencies
            .environmentObject(coordinator)
            .environmentObject(cartViewModel)
            .environmentObject(ordersViewModel)
            .environmentObject(notificationsViewModel)
            .environmentObject(container)
        }
    }
}
