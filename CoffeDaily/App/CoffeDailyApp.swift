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
    @StateObject private var container: AppContainer
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var cartViewModel: CartViewModel
    @StateObject private var ordersViewModel: OrdersViewModel
    @StateObject private var notificationsViewModel: NotificationsViewModel
    @StateObject private var homeViewModel: CoffeeHomeViewModel
    @StateObject private var profileViewModel: ProfileViewModel

    init() {
        let container = AppContainer()

        _container = StateObject(wrappedValue: container)
        _coordinator = StateObject(wrappedValue: AppCoordinator())

        _cartViewModel = StateObject(wrappedValue:
            CartViewModel(
                getCart: container.getCart,
                add: container.addToCart,
                update: container.updateCartItem,
                remove: container.removeFromCart,
                clear: container.clearCart,
                observeTotals: container.observeCartTotals
            )
        )

        _ordersViewModel = StateObject(wrappedValue:
            OrdersViewModel(
                place: container.placeOrder,
                fetch: container.fetchOrders,
                reorder: container.reorder
            )
        )

        _notificationsViewModel = StateObject(wrappedValue:
            NotificationsViewModel(fetch: container.fetchNotifications)
        )

        _homeViewModel = StateObject(wrappedValue:
            CoffeeHomeViewModel(fetchLocations: container.fetchLocations)
        )

        _profileViewModel = StateObject(wrappedValue:
            ProfileViewModel(getUser: container.getCurrentUser, saveUser: container.saveProfile)
        )
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                CoffeeHomeView()
            }
            .environmentObject(coordinator)
            .environmentObject(container)
            .environmentObject(cartViewModel)
            .environmentObject(ordersViewModel)
            .environmentObject(notificationsViewModel)
            .environmentObject(homeViewModel)
            .environmentObject(profileViewModel)
        }
    }
}
