//
//  CoffeeMenuScreen.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

//
//  CoffeeMenuScreen.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import SwiftUI

struct CoffeeMenuScreen: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var cartViewModel: CartViewModel

    @StateObject private var viewModel: CoffeeMenuViewModel

    init(fetchMenu: FetchMenuUseCase) {
        _viewModel = StateObject(wrappedValue: CoffeeMenuViewModel(fetchMenu: fetchMenu))
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.brown.opacity(0.7), Color.black],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            Group {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                } else if let error = viewModel.error {
                    Text(error).foregroundStyle(.white.opacity(0.9))
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(viewModel.menu) { item in
                                CoffeeMenuCard(item: item)
                                    .environmentObject(cartViewModel)
                                    .padding(.horizontal, 16)
                            }
                        }
                        .padding(.top, 12)
                        .padding(.bottom, 36)
                    }
                }
            }

            // Floating cart button with badge
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack(alignment: .topTrailing) {
                        Button {
                            coordinator.navigate(to: .cart)
                        } label: {
                            Image(systemName: "cart")
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(.white)
                                .frame(width: 56, height: 56)
                                .background(Circle().fill(Color.mint.opacity(0.85)))
                                .shadow(color: Color.black.opacity(0.4), radius: 8, y: 4)
                        }
                        if cartViewModel.totalCount > 0 {
                            Text("\(cartViewModel.totalCount)")
                                .font(.caption2.bold())
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Circle().fill(Color.red))
                                .offset(x: 8, y: -8)
                                .scaleEffect(cartViewModel.animateBadge ? 1.2 : 1)
                        }
                    }
                    .padding(.trailing, 24)
                    .padding(.bottom, 16)
                }
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
                Text("Меню")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible,           for: .navigationBar)
        .task { await viewModel.load() }
    }
}
