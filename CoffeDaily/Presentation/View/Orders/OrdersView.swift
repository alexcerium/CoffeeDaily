//
//  OrdersView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

//
//  OrdersView.swift
//  CoffeDaily
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
            LinearGradient(colors: [.mocha, .mint], startPoint: .top, endPoint: .bottom)
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
                                            Task {
                                                let items = await ordersViewModel.itemsForReorder(orderDocId: order.id)
                                                await MainActor.run {
                                                    cartViewModel.replace(with: items)
                                                    coordinator.navigate(to: .cart)
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "arrow.clockwise.circle")
                                                .font(.title2)
                                                .foregroundStyle(.white)
                                        }
                                    }

                                    ForEach(order.lines) { line in
                                        HStack {
                                            Text("\(line.qty)× \(line.title) (\(line.size))")
                                                .font(.subheadline)
                                                .foregroundStyle(.white)
                                            Spacer()
                                            let lineTotal = line.unitPrice * Double(line.qty)
                                            Text("€\(lineTotal, specifier: "%.2f")")
                                                .font(.subheadline.weight(.medium))
                                                .foregroundStyle(.white)
                                        }
                                    }

                                    Divider().overlay(Color.white.opacity(0.2))
                                    HStack {
                                        Spacer()
                                        Text("Итого: €\(order.total, specifier: "%.2f")")
                                            .font(.subheadline.weight(.semibold))
                                            .foregroundStyle(.white)
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
        .task { await ordersViewModel.load() }
    }
}
