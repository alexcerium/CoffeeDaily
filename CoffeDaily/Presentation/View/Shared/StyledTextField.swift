//
//  StyledTextField.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// StyledTextField.swift
import SwiftUI

struct StyledTextField: View {
    enum Kind { case email, password, name }
    let title: String
    let kind: Kind
    @Binding var text: String

    var body: some View {
        Group {
            if kind == .password {
                SecureField(title, text: $text)
                    .textContentType(.password)
            } else {
                TextField(title, text: $text)
                    .textInputAutocapitalization(.never)
                    .textContentType(kind == .email ? .emailAddress : .name)
                    .keyboardType(kind == .email ? .emailAddress : .default)
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 52)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule().strokeBorder(Color.white.opacity(0.18), lineWidth: 1)
        )
        .foregroundStyle(.white)
    }
}
