//
//  PromoCardView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

import SwiftUI

/// Swipeable carousel inside a glass card.
import SwiftUI

struct SampleCarouselCardView: View {
    let images:   [String]      // names in Assets
    let captions: [String]      // promo text for each image

    @State private var index = 0
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    var body: some View {
        GlassCard {
            TabView(selection: $index) {
                ForEach(images.indices, id: \.self) { i in
                    ZStack(alignment: .bottomLeading) {
                        spatialImage(images[i])
                        // Caption overlay
                        Text(captions[i])
                            .font(.headline.weight(.semibold))
                            .padding(12)
                            .foregroundStyle(.white)
                            .background(.black.opacity(0.4))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding()
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 240)
            .onReceive(timer) { _ in
                withAnimation {
                    index = (index + 1) % images.count
                }
            }
        }
    }

    /// Applies blurred edge mask to make photo look spatial (visionOS‑style)
    @ViewBuilder
    private func spatialImage(_ name: String) -> some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width  = geo.size.width
            ZStack {
                // Blurred copy expands outward to create soft edge
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .blur(radius: 20)
                    .clipped()
                // Sharp center image masked with fade to create blend
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .mask(
                        RadialGradient(
                            gradient: Gradient(stops: [
                                .init(color: .white,       location: 0.7),
                                .init(color: .white.opacity(0), location: 1)
                            ]),
                            center: .center,
                            startRadius: 0,
                            endRadius: max(width, height) * 0.8)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}
