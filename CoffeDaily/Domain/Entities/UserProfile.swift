//
//  UserProfile.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

public struct UserProfile: Equatable {
    public var name: String
    public var email: String
    public init(name: String = "", email: String = "") {
        self.name = name; self.email = email
    }
}
