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
    
    // DI container with easy source switch
    @StateObject private var container = AppContainer(dataSource: .rest) // ← switch to .firebase to use Firebase data
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                CoffeeHomeView()
                    .toolbar(.visible, for: .navigationBar)
                    .toolbar {
                        // Simple runtime switch (example); remove in production
                        ToolbarItem(placement: .topBarTrailing) {
                            Menu("Data") {
                                Button("Use REST") { container.switchTo(.rest) }
                                Button("Use Firebase") { container.switchTo(.firebase) }
                            }
                        }
                    }
            }
        }
    }
}
