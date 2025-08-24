//
//  ProfileView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var registered = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha, .mint],
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                if registered {
                    Text("Добро пожаловать, \(name)!")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.top, 40)
                } else {
                    Text("Регистрация")
                        .font(.largeTitle.weight(.bold))
                        .foregroundStyle(.white)
                        .padding(.top, 40)

                    Group {
                        TextField("Имя", text: $name)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                        SecureField("Пароль", text: $password)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.horizontal, 24)

                    Button {
                        registered = true
                        // здесь можно сохранять учётку
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
            // та же стрелка «назад»
            ToolbarItem(placement: .navigationBarLeading) {
                Button { coordinator.pop() } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                }
            }
            // заголовок «Профиль» на том же уровне
            ToolbarItem(placement: .principal) {
                Text("Профиль")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
            }
        }
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible,           for: .navigationBar)
    }
}
