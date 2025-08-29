//
//  AppContainer.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation
import FirebaseAuth

@MainActor
final class AppContainer: ObservableObject {
    // Repositories
    private(set) var coffeeRepository: CoffeeRepository
    private(set) var cartRepository: CartRepository
    private(set) var ordersRepository: OrdersRepository
    private(set) var notificationsRepository: NotificationsRepository
    private(set) var locationsRepository: LocationsRepository
    private(set) var userRepository: UserRepository
    private(set) var authRepository: AuthRepository

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

    // Auth
    private(set) var observeAuth: ObserveAuthUseCase
    private(set) var signInEmail: SignInEmailUseCase
    private(set) var registerEmail: RegisterEmailUseCase
    private(set) var signInAnonymously: SignInAnonUseCase
    private(set) var linkAnonymousToEmail: LinkAnonToEmailUseCase
    private(set) var signOut: SignOutUseCase

    init() {
        let uidProvider: () -> String? = { Auth.auth().currentUser?.uid }
        let resolveById: (UUID) -> CoffeeItem? = { MenuIndex.shared.item(by: $0) }

        let authRepo = FirebaseAuthRepository()
        let coffeeRepo = FirebaseCoffeeRepository()
        let cartRepo   = FirebaseCartRepository(uidProvider: uidProvider, resolveItem: resolveById)
        let ordersRepo = FirebaseOrdersRepository(uidProvider: uidProvider, resolveItem: resolveById)
        let notesRepo  = FirebaseNotificationsRepository(uidProvider: uidProvider)
        let locsRepo   = FirebaseLocationsRepository()
        let userRepo   = FirebaseUserRepository()

        self.authRepository = authRepo
        self.coffeeRepository = coffeeRepo
        self.cartRepository = cartRepo
        self.ordersRepository = ordersRepo
        self.notificationsRepository = notesRepo
        self.locationsRepository = locsRepo
        self.userRepository = userRepo

        self.fetchMenu = FetchMenuUseCase(repository: coffeeRepo)

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

        self.observeAuth = ObserveAuthUseCase(repo: authRepo)
        self.signInEmail = SignInEmailUseCase(repo: authRepo)
        self.registerEmail = RegisterEmailUseCase(repo: authRepo)
        self.signInAnonymously = SignInAnonUseCase(repo: authRepo)
        self.linkAnonymousToEmail = LinkAnonToEmailUseCase(repo: authRepo)
        self.signOut = SignOutUseCase(repo: authRepo)
    }
}
