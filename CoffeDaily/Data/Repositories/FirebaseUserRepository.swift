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

    private func requireUID() throws -> String {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
        }
        return uid
    }

    func currentUser() async throws -> UserProfile {
        let uid = try requireUID()
        let doc = try await db.collection("users").document(uid)
            .collection("profile").document("main")
            .getDocument()

        if doc.exists, let dto = try? doc.data(as: UserProfileDTO.self) {
            return .init(name: dto.name, email: dto.email)
        }

        let email = Auth.auth().currentUser?.email ?? ""
        return .init(name: "", email: email)
    }

    func saveProfile(_ profile: UserProfile) async throws {
        let uid = try requireUID()

        // 1) Сохраняем профиль в Firestore
        let dto = UserProfileDTO(name: profile.name, email: profile.email)
        try db.collection("users").document(uid)
            .collection("profile").document("main")
            .setData(from: dto, merge: true)

        // 2) Синхронизируем email в Firebase Auth с современной API.
        if let user = Auth.auth().currentUser,
           !user.isAnonymous,
           !profile.email.isEmpty,
           user.email != profile.email {
            // Отправляет письмо подтверждения на новый email и инициирует обновление адреса после подтверждения.
            try await user.sendEmailVerification(beforeUpdatingEmail: profile.email)
        }
    }
}
