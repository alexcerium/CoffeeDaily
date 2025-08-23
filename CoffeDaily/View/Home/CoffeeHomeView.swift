//
//  CoffeeHomeView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.

import SwiftUI
import MapKit

struct CoffeeHomeView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var ordersViewModel: OrdersViewModel
    @EnvironmentObject private var notificationsViewModel: NotificationsViewModel
    @StateObject private var viewModel = CoffeeHomeViewModel()

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha, .mint], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 28) {
                    HeaderBarView()
                    TitleView(text: "Добро пожаловать в CoffeeDaily!")
                    SampleCarouselCardView(
                        images: ["breakfast1", "breakfast2", "breakfast3"],
                        captions: ["−20 % на сеты завтрака",
                                   "Круассан в подарок к латте",
                                   "Смузи дня — 3 € 50"]
                    )
                    ActionButtonsView()
                    LocationsMapCardView(region: $viewModel.region, locations: viewModel.locations)
                }
                .padding(.horizontal)
                .padding(.top, 12)
                .padding(.bottom, 36)
            }
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .home: EmptyView()
            case .menu: CoffeeMenuScreen()
            case .orders: OrdersView()
            case .cart: CartView()
            case .payment: PaymentView()
            case .profile: ProfileView()
            case .notifications: NotificationsView()
            }
        }
        .navigationBarHidden(true)
    }
}
