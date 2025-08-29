//
//  PaymentView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

//
//  PaymentView.swift
//  CoffeDaily
//

import SwiftUI

struct PaymentView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var ordersViewModel: OrdersViewModel

    @State private var isWorking = false
    @State private var showError = false
    @State private var errorText = ""

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha, .mint], startPoint: .top, endPoint: .bottom)
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
                    guard !isWorking else { return }
                    isWorking = true
                    Task {
                        do {
                            try await ordersViewModel.placeOrder(from: cartViewModel.items)
                            try await cartViewModel.clear()
                            coordinator.navigate(to: .orders)
                        } catch {
                            await MainActor.run {
                                errorText = error.localizedDescription
                                showError = true
                            }
                        }
                        isWorking = false
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
                .opacity(isWorking ? 0.7 : 1)
            }

            if isWorking { ProgressView().tint(.white) }
            if showError {
                VStack {
                    Toast(style: .error, message: errorText)
                        .padding(.top, 12)
                    Spacer()
                }
                .padding(.horizontal, 16)
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
