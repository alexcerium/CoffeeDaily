//
//  GlassCard.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.ultraThinMaterial)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.05), Color.white.opacity(0.01)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
            )
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
