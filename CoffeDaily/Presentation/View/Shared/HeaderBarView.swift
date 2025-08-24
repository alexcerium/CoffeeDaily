//
//  HeaderBarView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

import SwiftUI

struct HeaderBarView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        HStack {
            // Профиль
            Button {
                coordinator.navigate(to: .profile)
            } label: {
                Image(systemName: "person.circle")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 30))
            }

            Spacer()

            // Уведомления
            Button {
                coordinator.navigate(to: .notifications)
            } label: {
                Image(systemName: "bell.circle")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 30))
            }
        }
        .foregroundColor(.white.opacity(0.9))
    }
}
