//
//  PillButton.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import SwiftUI

struct PillButton: View {
    let title: String
    let sfSymbol: String?
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let sf = sfSymbol {
                    Image(systemName: sf)
                        .font(.headline)
                }
                Text(title)
                    .font(.headline.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.08))
                )
        )
        .overlay(
            Capsule()
                .strokeBorder(Color.white.opacity(0.25), lineWidth: 1)
        )
        .shadow(radius: 4, y: 2)
    }
}
