//
//  OrdersViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import Foundation

final class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
}
