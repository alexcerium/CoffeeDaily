//
//  ProfileView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 21.04.2025.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var viewModel: ProfileViewModel
    @EnvironmentObject private var container: AppContainer

    @State private var localName = ""
    @State private var localEmail = ""
    @State private var working = false
    @State private var showSaved = false
    @State private var showError = false
    @State private var errorText = ""

    private var isAnonymous: Bool { Auth.auth().currentUser?.isAnonymous ?? true }

    private func save() {
        working = true
        Task {
            do {
                viewModel.name = localName
                viewModel.email = localEmail
                try await container.saveProfile.execute(.init(name: localName, email: localEmail))
                withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) { showSaved = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { withAnimation { showSaved = false } }
            } catch {
                errorText = error.localizedDescription
                withAnimation { showError = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { withAnimation { showError = false } }
            }
            working = false
        }
    }

    private func linkGuest() { coordinator.pop() }
    private func signOut() { Task { try? await container.signOut.execute() } }

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mocha, .mint], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Убрали Text("Профиль") — заголовок теперь только в тулбаре

                    GlassCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(isAnonymous ? "Гость" : "Аккаунт")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.9))

                            StyledTextField(title: "Имя",   kind: .name,  text: $localName)
                            StyledTextField(title: "Email", kind: .email, text: $localEmail)

                            HStack(spacing: 12) {
                                PillButton(title: "Сохранить", sfSymbol: "checkmark.circle") { save() }
                                PillButton(title: "Выйти",     sfSymbol: "rectangle.portrait.and.arrow.right") { signOut() }
                            }
                            .frame(height: 52)
                        }
                        .padding(.vertical, 6)
                    }
                    .padding(.horizontal, 24)

                    if isAnonymous {
                        GlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Апгрейд аккаунта")
                                    .font(.headline.weight(.semibold))
                                    .foregroundStyle(.white)
                                Text("Вы вошли как гость. Свяжите профиль с email, чтобы сохранять заказы и настройки.")
                                    .font(.subheadline)
                                    .foregroundStyle(.white.opacity(0.8))
                                PillButton(title: "Связать с email", sfSymbol: "link") { linkGuest() }
                                    .frame(height: 48)
                            }
                        }
                        .padding(.horizontal, 24)
                    }

                    Spacer(minLength: 20)
                }
                .padding(.bottom, 30)
            }

            if working { ProgressView().tint(.white) }

            VStack {
                if showSaved { Toast(style: .success, message: "Сохранено").padding(.top, 10) }
                if showError { Toast(style: .error, message: errorText).padding(.top, 10) }
                Spacer()
            }
            .padding(.horizontal, 16)
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
        .task {
            await viewModel.load()
            localName = viewModel.name
            localEmail = viewModel.email
        }
    }
}
