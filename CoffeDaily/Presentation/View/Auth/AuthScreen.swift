//
//  AuthScreen.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import SwiftUI

struct AuthScreen: View {
    let signInEmail: SignInEmailUseCase
    let registerEmail: RegisterEmailUseCase
    let signInAnon: SignInAnonUseCase
    let linkAnonToEmail: LinkAnonToEmailUseCase

    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @State private var errorText = ""
    @State private var showSuccess = false

    @State private var isWorking = false
    @Namespace private var ns

    private func run(_ block: @escaping () async throws -> Void, success: String? = nil) {
        isWorking = true
        Task {
            do {
                try await block()
                if let s = success {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        errorText = ""; showError = false; showSuccess = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation { showSuccess = false }
                    }
                }
            } catch {
                errorText = error.localizedDescription
                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) { showError = true }
                // «shake»
                let impact = UIImpactFeedbackGenerator(style: .rigid); impact.impactOccurred()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                    withAnimation { showError = false }
                }
            }
            isWorking = false
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha, .mint], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("CoffeeDaily")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white.opacity(0.95))

                GlassCard {
                    VStack(spacing: 14) {
                        Text("Вход или регистрация")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.white)

                        StyledTextField(title: "Email",    kind: .email,    text: $email)
                        StyledTextField(title: "Пароль",  kind: .password, text: $password)

                        HStack(spacing: 12) {
                            PillButton(title: "Войти", sfSymbol: "arrow.right") {
                                run({ try await signInEmail.execute(email: email, password: password) }, success: "Выполнен вход")
                            }
                            .frame(height: 52)

                            PillButton(title: "Создать", sfSymbol: "person.badge.plus") {
                                run({ try await registerEmail.execute(email: email, password: password) }, success: "Аккаунт создан")
                            }
                            .frame(height: 52)
                        }

                        PillButton(title: "Гость", sfSymbol: "person.crop.circle.badge.questionmark") {
                            run({ try await signInAnon.execute() }, success: "Гостевой вход")
                        }
                        .frame(height: 52)

                        PillButton(title: "Связать гость → Email", sfSymbol: "link") {
                            run({ try await linkAnonToEmail.execute(email: email, password: password) }, success: "Гость связан с email")
                        }
                        .frame(height: 52)

                        // Провайдеры (подключите обработчики при необходимости)
                        HStack(spacing: 12) {
                            PillButton(title: "Google", sfSymbol: "g.circle") { /* TODO */ }
                            PillButton(title: "Apple",  sfSymbol: "apple.logo") { /* TODO */ }
                        }
                        .frame(height: 48)
                        .opacity(0.9)
                    }
                    .padding(.vertical, 6)
                }
                .matchedGeometryEffect(id: "card", in: ns)
                .padding(.horizontal, 24)

                Spacer(minLength: 16)
            }

            if isWorking {
                ProgressView().tint(.white)
            }

            VStack {
                if showError { Toast(style: .error, message: errorText).padding(.top, 10) }
                if showSuccess { Toast(style: .success, message: "Готово").padding(.top, 10) }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.9), value: showError)
        .animation(.spring(response: 0.4, dampingFraction: 0.9), value: showSuccess)
        .padding(.top, 12)
    }
}
