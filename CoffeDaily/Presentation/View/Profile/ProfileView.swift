//
//  ProfileView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

//
//  ProfileView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var viewModel: ProfileViewModel
    @State private var password = "" // демо, не сохраняется

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha, .mint],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                if viewModel.saved {
                    Text("Добро пожаловать, \(viewModel.name)!")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.top, 40)
                } else {
                    Text("Регистрация")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.top, 40)

                    Group {
                        TextField("Имя", text: $viewModel.name)
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                        SecureField("Пароль", text: $password)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)

                    Button {
                        Task { await viewModel.save() }
                    } label: {
                        Text("Зарегистрироваться")
                            .font(.headline.weight(.semibold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Capsule().fill(Color.mint))
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                    }
                }

                Spacer()
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
                Text("Профиль")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible,           for: .navigationBar)
        .task { await viewModel.load() }
    }
}
