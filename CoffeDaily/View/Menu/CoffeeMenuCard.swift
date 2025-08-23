//
//  CoffeeMenuCard.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import SwiftUI

struct CoffeeMenuCard: View {
    let item: CoffeeItem
    @State private var selectedSize: String = "M"
    private let sizes = ["S", "M", "L"]
    @EnvironmentObject private var cartViewModel: CartViewModel
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 16) {
            Image(item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)

            VStack(alignment: .leading, spacing: 8) {
                Text(item.title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)

                Text(item.description)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)

                HStack(spacing: 10) {
                    ForEach(sizes, id: \.self) { size in
                        Button {
                            selectedSize = size
                        } label: {
                            Text(size)
                                .font(.subheadline.weight(.semibold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(selectedSize == size
                                              ? Color.white.opacity(0.25)
                                              : Color.clear)
                                )
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(.plain)
                    }
                }

                HStack {
                    Text("€\(item.prices[selectedSize]!, specifier: "%.2f")")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)

                    Spacer()

                    PillButton(title: "Добавить", sfSymbol: "plus") {
                        cartViewModel.add(item, size: selectedSize)
                    }
                    .frame(minWidth: 100)   // минимальная ширина
                    .frame(height: 40)      // увеличенная высота
                    .matchedGeometryEffect(id: "\(item.id)-\(selectedSize)", in: animation)
                }
                .padding(.top, 4)
            }

            Spacer()
        }
        .padding()
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
        .shadow(radius: 4, y: 2)
    }
}
