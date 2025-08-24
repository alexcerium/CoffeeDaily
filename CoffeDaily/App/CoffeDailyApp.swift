//
//  CoffeDailyApp.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct CoffeeDailyApp: App {
    

    @StateObject private var container: AppContainer
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var sessionViewModel: SessionViewModel
    @StateObject private var cartViewModel: CartViewModel
    @StateObject private var ordersViewModel: OrdersViewModel
    @StateObject private var notificationsViewModel: NotificationsViewModel
    @StateObject private var homeViewModel: CoffeeHomeViewModel
    @StateObject private var profileViewModel: ProfileViewModel

    init() {
        // 1) Конфигурируем Firebase раньше всего
        if FirebaseApp.app() == nil { FirebaseApp.configure() }

        // 2) Включаем офлайн-кэш
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        Firestore.firestore().settings = settings

        // 3) Теперь можно создавать DI (репозитории будут безопасно обращаться к Firestore)
        let container = AppContainer()
        _container  = StateObject(wrappedValue: container)
        _coordinator = StateObject(wrappedValue: AppCoordinator())
        _sessionViewModel = StateObject(wrappedValue:
            SessionViewModel(
                observeAuth: container.observeAuth,
                signInAnon:  container.signInAnonymously,
                signOut:     container.signOut
            )
        )
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
            OrdersViewModel(place: container.placeOrder,
                            fetch: container.fetchOrders,
                            reorder: container.reorder)
        )
        _notificationsViewModel = StateObject(wrappedValue:
            NotificationsViewModel(fetch: container.fetchNotifications)
        )
        _homeViewModel = StateObject(wrappedValue:
            CoffeeHomeViewModel(fetchLocations: container.fetchLocations)
        )
        _profileViewModel = StateObject(wrappedValue:
            ProfileViewModel(getUser: container.getCurrentUser,
                             saveUser: container.saveProfile)
        )
    }

    var body: some Scene {
        WindowGroup {
            Group {
                switch sessionViewModel.state {
                case .loading:
                    ZStack { Color.clear.ignoresSafeArea(); ProgressView() }
                case .unauthorized:
                    AuthScreen(
                        signInEmail: container.signInEmail,
                        registerEmail: container.registerEmail,signInAnon:         container.signInAnonymously,  
                        linkAnonToEmail: container.linkAnonymousToEmail
                    )
                case .authorized:
                    NavigationStack(path: $coordinator.path) {
                        CoffeeHomeView()
                    }
                }
            }
            // Общее окружение для экранов приложения (home/cart/…)
            .environmentObject(coordinator)
            .environmentObject(container)
            .environmentObject(sessionViewModel)
            .environmentObject(cartViewModel)
            .environmentObject(ordersViewModel)
            .environmentObject(notificationsViewModel)
            .environmentObject(homeViewModel)
            .environmentObject(profileViewModel)
        }
    }
}
