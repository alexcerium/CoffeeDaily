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

    static func sha256Hex(_ text: String) -> String {
        let digest = SHA256.hash(data: Data(text.utf8))
        return digest.compactMap { String(format: "%02x", $0) }.joined()
    }
}

enum CartMapper {
    static func toEntity(_ dto: CartItemDTO, resolve: (UUID) -> CoffeeItem?) -> CartItem? {
        guard let uuid = UUID(uuidString: dto.itemId), let item = resolve(uuid) else { return nil }
        return CartItem(item: item, size: dto.size, quantity: dto.qty)
    }

    static func toEntityLenient(_ dto: CartItemDTO, resolve: (UUID) -> CoffeeItem?) -> CartItem {
        let uuid = UUID(uuidString: dto.itemId) ?? StableID.fromString(dto.itemId)
        let item = resolve(uuid) ?? CoffeeItem(id: uuid, imageName: "placeholder", title: "…", description: "", prices: [:])
        return CartItem(item: item, size: dto.size, quantity: dto.qty)
    }

    static func toDTO(_ entity: CartItem) -> CartItemDTO {
        .init(id: nil, itemId: entity.item.id.uuidString, size: entity.size, qty: entity.quantity)
    }
}

enum OrderMapper {
    static func toEntity(_ dto: OrderDTO, resolve: (UUID) -> CoffeeItem?) -> Order? {
        guard let docId = dto.id else { return nil }
        let lines: [OrderLine] = dto.items.compactMap { it in
            let uuid = UUID(uuidString: it.itemId) ?? StableID.fromString(it.itemId)
            return OrderLine(itemId: uuid, title: it.title, imageName: it.imageName, size: it.size, qty: it.qty, unitPrice: it.unitPrice)
        }
        return Order(id: docId, date: dto.date, lines: lines, total: dto.total)
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
