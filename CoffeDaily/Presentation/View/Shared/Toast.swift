//
//  Toast.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// Toast.swift
import SwiftUI

struct Toast: View {
    enum Style { case success, error }
    let style: Style
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: style == .success ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
            Text(message).font(.subheadline.weight(.semibold))
        }
        .padding(.horizontal, 14).frame(height: 44)
        .background(.ultraThinMaterial)
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color.white.opacity(0.2)))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .foregroundStyle(.white)
        .shadow(radius: 8, y: 4)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}
