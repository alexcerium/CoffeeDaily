//
//  CartItemCard.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import SwiftUI

struct CartItemCard: View {
    @Binding var cartItem: CartItem
    @EnvironmentObject private var cartViewModel: CartViewModel
    private let sizes = ["S", "M", "L"]

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(cartItem.item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(radius: 3)

            VStack(alignment: .leading, spacing: 6) {
                Text(cartItem.item.title)
                    .font(.headline)

                Picker("", selection: $cartItem.size) {
                    ForEach(sizes, id: \.self) { size in
                        Text(size).tag(size)
                    }
                }
                .pickerStyle(.segmented)
                .frame(height: 32)

                HStack(spacing: 12) {
                    Button {
                        if cartItem.quantity > 1 {
                            cartItem.quantity -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                            .font(.title2)
                    }

                    Text("\(cartItem.quantity)")
                        .font(.subheadline.weight(.semibold))
                        .frame(minWidth: 24)

                    Button {
                        cartItem.quantity += 1
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }

                Text("€\(cartItem.item.prices[cartItem.size]!, specifier: "%.2f")")
                    .font(.subheadline.weight(.medium))
            }

            Spacer()

            Button {
                cartViewModel.remove(cartItem)
            } label: {
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.white.opacity(0.15), lineWidth: 1)
        )
    }
}
