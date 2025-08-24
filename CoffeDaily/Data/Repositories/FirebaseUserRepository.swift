//
//  FirebaseUserRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import FirebaseAuth
import FirebaseFirestore

final class FirebaseUserRepository: UserRepository {
    private let db = Firestore.firestore()
    private var uid: String { Auth.auth().currentUser!.uid }

    func currentUser() async throws -> UserProfile {
        let doc = try await db.collection("users").document(uid)
            .collection("profile").document("main")
            .getDocument()

        if doc.exists, let dto = try? doc.data(as: UserProfileDTO.self) {
            return .init(name: dto.name, email: dto.email)
        }

        // если профиля нет, подставляем email из Auth (если есть)
        let email = Auth.auth().currentUser?.email ?? ""
        return .init(name: "", email: email)
    }

    func saveProfile(_ profile: UserProfile) async throws {
        // 1) Сохраняем профиль в Firestore
        let dto = UserProfileDTO(name: profile.name, email: profile.email)
        try db.collection("users").document(uid)
            .collection("profile").document("main")
            .setData(from: dto, merge: true)

        // 2) Синхронизируем email в Firebase Auth (если возможно)
        if let user = Auth.auth().currentUser,
           !user.isAnonymous,
           !profile.email.isEmpty,
           user.email != profile.email {
            // Для updateEmail может потребоваться недавняя реавторизация.
            try await user.updateEmail(to: profile.email)
            // Верификация — необязательно
            try? await user.sendEmailVerification()
        }
    }
}
