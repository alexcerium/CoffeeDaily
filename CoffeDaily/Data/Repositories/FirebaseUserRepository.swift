//
//  FirebaseUserRepository.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// Data/Repositories/FirebaseUserRepository.swift
import FirebaseAuth
import FirebaseFirestore

final class FirebaseUserRepository: UserRepository {
    private let db = Firestore.firestore()
    private var uid: String { Auth.auth().currentUser!.uid }

    func currentUser() async throws -> UserProfile {
        let doc = try await db.collection("users").document(uid).collection("profile").document("main").getDocument()
        if doc.exists, let dto = try? doc.data(as: UserProfileDTO.self) {
            return .init(name: dto.name, email: dto.email)
        }
        // если нет профиля, но есть email в Auth — подставим
        let email = Auth.auth().currentUser?.email ?? ""
        return .init(name: "", email: email)
    }

    func saveProfile(_ profile: UserProfile) async throws {
        let dto = UserProfileDTO(name: profile.name, email: profile.email)
        try db.collection("users").document(uid).collection("profile").document("main").setData(from: dto, merge: true)
        // синхронизируем email в Auth при необходимости
        if let user = Auth.auth().currentUser, profile.email.isEmpty == false, user.email != profile.email, !user.isAnonymous {
            try await user.sendEmailVerification() // опционально
        }
    }
}
