//
//  ProfileViewModel.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var saved: Bool = false

    private let getUser: GetCurrentUserUseCase
    private let saveUser: SaveProfileUseCase

    init(getUser: GetCurrentUserUseCase, saveUser: SaveProfileUseCase) {
        self.getUser = getUser
        self.saveUser = saveUser
    }

    func load() async {
        if let u = try? await getUser.execute() {
            name = u.name; email = u.email
        }
    }

    func save() async {
        let profile = UserProfile(name: name, email: email)
        try? await saveUser.execute(profile)
        saved = true
    }
}
