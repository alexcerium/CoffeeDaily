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
    @State private var error: String?

    var body: some View {
        VStack(spacing: 16) {
            Text("Вход / Регистрация").font(.largeTitle.bold())
            TextField("Email", text: $email).textInputAutocapitalization(.never).keyboardType(.emailAddress)
            SecureField("Пароль", text: $password)

            HStack {
                Button("Войти") {
                    Task { do { try await signInEmail.execute(email: email, password: password) } catch { self.error = error.localizedDescription } }
                }
                Button("Создать аккаунт") {
                    Task { do { try await registerEmail.execute(email: email, password: password) } catch { self.error = error.localizedDescription } }
                }
            }
            Button("Продолжить как гость") {
                Task { do { try await signInAnon.execute() } catch { self.error = error.localizedDescription } }
            }
            Button("Связать гостевой с Email") {
                Task { do { try await linkAnonToEmail.execute(email: email, password: password) } catch { self.error = error.localizedDescription } }
            }

            if let e = error { Text(e).foregroundStyle(.red) }
        }
        .padding()
    }
}
