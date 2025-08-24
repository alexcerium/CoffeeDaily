//
//  ActionButtonsView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.

import SwiftUI

struct ActionButtonsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        HStack(spacing: 20) {
            PillButton(title: "Меню", sfSymbol: "menucard") {
                coordinator.navigate(to: .menu)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)

            PillButton(title: "История", sfSymbol: "clock") {
                coordinator.navigate(to: .orders)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 64)
        }
        .padding(.horizontal, 24)
    }
}

