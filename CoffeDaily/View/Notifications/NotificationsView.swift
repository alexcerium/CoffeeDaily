//
//  NotificationsView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject private var notificationsViewModel: NotificationsViewModel
    @EnvironmentObject private var coordinator: AppCoordinator

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru_RU")
        df.dateStyle = .short
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
                    ForEach(notificationsViewModel.notifications) { note in
                        GlassCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(note.title)
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.white)
                                Text(note.message)
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                                Text(dateFormatter.string(from: note.date))
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            .padding()
                        }
                        .padding(.horizontal, 16)
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
                Text("Уведомления")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible,           for: .navigationBar)
    }
}
