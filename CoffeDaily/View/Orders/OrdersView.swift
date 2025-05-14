//
//  OrdersView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import SwiftUI

struct OrdersView: View {
    @EnvironmentObject private var ordersViewModel: OrdersViewModel
    @EnvironmentObject private var cartViewModel: CartViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateStyle = .medium
        df.timeStyle = .short
        return df
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha, .mint],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    if ordersViewModel.orders.isEmpty {
                        Text("История заказов пуста")
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.top, 40)
                    } else {
                        ForEach(ordersViewModel.orders) { order in
                            GlassCard {
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Заказ от \(dateFormatter.string(from: order.date))")
                                            .font(.headline.weight(.semibold))
                                            .foregroundStyle(.white)
                                        Spacer()
                                        Button {
                                            cartViewModel.items = order.items
                                            coordinator.navigate(to: .cart)
                                        } label: {
                                            Image(systemName: "arrow.clockwise.circle")
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    ForEach(order.items) { ci in
                                        HStack {
                                            Text("\(ci.quantity)× \(ci.item.title) (\(ci.size))")
                                                .font(.subheadline)
                                                .foregroundStyle(.white)
                                            Spacer()
                                            let lineTotal = ci.item.prices[ci.size]! * Double(ci.quantity)
                                            Text("€\(lineTotal, specifier: "%.2f")")
                                                .font(.subheadline.weight(.medium))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.vertical, 16)
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
                Text("История заказов")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible,           for: .navigationBar)
    }
}
