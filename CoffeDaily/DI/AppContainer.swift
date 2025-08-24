//
//  AppContainer.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

//
//  AppContainer.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

@MainActor
final class AppContainer: ObservableObject {
    // Repositories
    private(set) var coffeeRepository: CoffeeRepository
    private(set) var cartRepository: CartRepository
    private(set) var ordersRepository: OrdersRepository
    private(set) var notificationsRepository: NotificationsRepository
    private(set) var locationsRepository: LocationsRepository
    private(set) var userRepository: UserRepository

    // Use cases
    private(set) var fetchMenu: FetchMenuUseCase
    // Cart
    private(set) var getCart: GetCartUseCase
    private(set) var addToCart: AddToCartUseCase
    private(set) var updateCartItem: UpdateCartItemUseCase
    private(set) var removeFromCart: RemoveFromCartUseCase
    private(set) var clearCart: ClearCartUseCase
    private(set) var observeCartTotals: ObserveCartTotalsUseCase
    // Orders
    private(set) var placeOrder: PlaceOrderUseCase
    private(set) var fetchOrders: FetchOrdersUseCase
    private(set) var reorder: ReorderUseCase
    // Notifications
    private(set) var fetchNotifications: FetchNotificationsUseCase
    // Locations
    private(set) var fetchLocations: FetchLocationsUseCase
    // User
    private(set) var getCurrentUser: GetCurrentUserUseCase
    private(set) var saveProfile: SaveProfileUseCase

    init() {
        // Firebase-only: меню
        let client = FakeFirebaseClient()
        let coffeeRepo = FirebaseCoffeeRepository(client: client)
        self.coffeeRepository = coffeeRepo
        self.fetchMenu = FetchMenuUseCase(repository: coffeeRepo)

        // Resolver без захвата self
        let resolveById: (UUID) -> CoffeeItem? = { id in
            MenuIndex.shared.item(by: id)
        }

        // Остальные репозитории
        let cartRepo = FirebaseCartRepository(resolveItem: resolveById)
        let ordersRepo = FirebaseOrdersRepository(resolveItem: resolveById)
        let notesRepo  = FirebaseNotificationsRepository()
        let locsRepo   = FirebaseLocationsRepository()
        let userRepo   = FirebaseUserRepository()

        self.cartRepository = cartRepo
        self.ordersRepository = ordersRepo
        self.notificationsRepository = notesRepo
        self.locationsRepository = locsRepo
        self.userRepository = userRepo

        // Use cases
        self.getCart = GetCartUseCase(repo: cartRepo)
        self.addToCart = AddToCartUseCase(repo: cartRepo)
        self.updateCartItem = UpdateCartItemUseCase(repo: cartRepo)
        self.removeFromCart = RemoveFromCartUseCase(repo: cartRepo)
        self.clearCart = ClearCartUseCase(repo: cartRepo)
        self.observeCartTotals = ObserveCartTotalsUseCase(repo: cartRepo)

        self.placeOrder = PlaceOrderUseCase(repo: ordersRepo)
        self.fetchOrders = FetchOrdersUseCase(repo: ordersRepo)
        self.reorder = ReorderUseCase(repo: ordersRepo)

        self.fetchNotifications = FetchNotificationsUseCase(repo: notesRepo)
        self.fetchLocations     = FetchLocationsUseCase(repo: locsRepo)

        self.getCurrentUser = GetCurrentUserUseCase(repo: userRepo)
        self.saveProfile    = SaveProfileUseCase(repo: userRepo)
    }
}
