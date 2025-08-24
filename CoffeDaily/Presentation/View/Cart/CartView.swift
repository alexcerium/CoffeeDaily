//
//  CartView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha.opacity(0.6), .mint],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                if cartViewModel.items.isEmpty {
                    Spacer()
                    Text("Ваша корзина пуста")
                        .foregroundStyle(.white.opacity(0.7))
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach($cartViewModel.items, id: \.id) { $ci in
                                CartItemCard(cartItem: $ci)
                                    .environmentObject(cartViewModel)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }

                    PillButton(title: "Заказать", sfSymbol: nil) {
                        coordinator.navigate(to: .payment)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 64)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { coordinator.pop() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Корзина")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible,           for: .navigationBar)
    }
}
