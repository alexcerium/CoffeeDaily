//
//  MenuIndex.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

final class MenuIndex {
    static let shared = MenuIndex()
    private init() {}
    private var map: [UUID: CoffeeItem] = [:]

    func update(_ items: [CoffeeItem]) {
        map = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
    }

    func item(by id: UUID) -> CoffeeItem? { map[id] }
}
