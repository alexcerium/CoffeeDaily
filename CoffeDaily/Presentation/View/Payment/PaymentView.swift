//
//  PaymentView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import SwiftUI

struct PaymentView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var ordersViewModel: OrdersViewModel

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha, .mint],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                Text("Способы оплаты скоро появятся")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                Spacer()

                PillButton(title: "Оплатить", sfSymbol: nil) {
                    let newOrder = Order(date: Date(), items: cartViewModel.items)
                    ordersViewModel.orders.append(newOrder)
                    cartViewModel.items.removeAll()
                    coordinator.navigate(to: .orders)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
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
                Text("Оплата")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible,           for: .navigationBar)
    }
}
