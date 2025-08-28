//
//  GeneralMappers.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation
import CoreLocation
import CryptoKit

enum StableID {
    static func fromString(_ string: String) -> UUID {
        if let u = UUID(uuidString: string) { return u }
        let digest = SHA256.hash(data: Data(string.utf8))
        let bytes = [UInt8](digest)
        return UUID(uuid: (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5], bytes[6], bytes[7],
            bytes[8], bytes[9], bytes[10], bytes[11],
            bytes[12], bytes[13], bytes[14], bytes[15]
        ))
    }

    static func fromOptional(_ string: String?, seed: String) -> UUID {
        if let s = string { return fromString(s) }
        return fromString("seed:\(seed)")
    }
}

enum CartMapper {
    /// Strict mapping: drops row if item can't be resolved.
    static func toEntity(_ dto: CartItemDTO, resolve: (UUID) -> CoffeeItem?) -> CartItem? {
        guard let uuid = UUID(uuidString: dto.itemId), let item = resolve(uuid) else { return nil }
        return CartItem(item: item, size: dto.size, quantity: dto.qty)
    }

    /// Lenient mapping: preserves row with a placeholder when index is not ready.
    static func toEntityLenient(_ dto: CartItemDTO, resolve: (UUID) -> CoffeeItem?) -> CartItem {
        let uuid = UUID(uuidString: dto.itemId) ?? StableID.fromString(dto.itemId)
        let item = resolve(uuid) ?? CoffeeItem(
            id: uuid,
            imageName: "placeholder",
            title: "…",
            description: "",
            prices: [:]
        )
        return CartItem(item: item, size: dto.size, quantity: dto.qty)
    }

    static func toDTO(_ entity: CartItem) -> CartItemDTO {
        .init(id: nil, itemId: entity.item.id.uuidString, size: entity.size, qty: entity.quantity)
    }
}

enum OrderMapper {
    static func toEntity(_ dto: OrderDTO, resolve: (UUID) -> CoffeeItem?) -> Order? {
        let items = dto.items.map { CartMapper.toEntityLenient($0, resolve: resolve) }
        let iso = ISO8601DateFormatter().string(from: dto.date)
        let id = StableID.fromOptional(dto.id, seed: iso)
        return Order(id: id, date: dto.date, items: items)
    }

    static func toDTO(_ entity: Order) -> OrderDTO {
        .init(id: nil, date: entity.date, items: entity.items.map { CartMapper.toDTO($0) })
    }
}

enum NotificationMapper {
    static func toEntity(_ dto: NotificationDTO) -> NotificationItem {
        let id = StableID.fromOptional(dto.id, seed: dto.title + dto.message)
        return NotificationItem(id: id, title: dto.title, message: dto.message, date: dto.date)
    }
}

enum LocationMapper {
    static func toEntity(_ dto: LocationDTO) -> CoffeeLocation {
        let id = StableID.fromOptional(dto.id, seed: "\(dto.latitude),\(dto.longitude)")
        return CoffeeLocation(id: id, coordinate: .init(latitude: dto.latitude, longitude: dto.longitude))
    }
}

enum UserProfileMapper {
    static func toEntity(_ dto: UserProfileDTO) -> UserProfile { .init(name: dto.name, email: dto.email) }
    static func toDTO(_ entity: UserProfile) -> UserProfileDTO { .init(name: entity.name, email: entity.email) }
}
