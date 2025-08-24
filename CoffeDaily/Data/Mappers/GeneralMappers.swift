//
//  GeneralMappers.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// Data/Mappers/GeneralMappers.swift
import Foundation
import CoreLocation

enum CartMapper {
    static func toEntity(_ dto: CartItemDTO, resolve: (UUID) -> CoffeeItem?) -> CartItem? {
        guard let uuid = UUID(uuidString: dto.itemId), let item = resolve(uuid) else { return nil }
        return CartItem(item: item, size: dto.size, quantity: dto.qty)
    }
    static func toDTO(_ entity: CartItem) -> CartItemDTO {
        .init(id: nil, itemId: entity.item.id.uuidString, size: entity.size, qty: entity.quantity)
    }
}

enum OrderMapper {
    static func toEntity(_ dto: OrderDTO, resolve: (UUID) -> CoffeeItem?) -> Order? {
        let items = dto.items.compactMap { CartMapper.toEntity($0, resolve: resolve) }
        return Order(id: UUID(), date: dto.date, items: items)
    }
    static func toDTO(_ entity: Order) -> OrderDTO {
        .init(id: nil, date: entity.date, items: entity.items.map(CartMapper.toDTO(_:)))
    }
}

enum NotificationMapper {
    static func toEntity(_ dto: NotificationDTO) -> NotificationItem {
        NotificationItem(id: UUID(), title: dto.title, message: dto.message, date: dto.date)
    }
}

enum LocationMapper {
    static func toEntity(_ dto: LocationDTO) -> CoffeeLocation {
        CoffeeLocation(id: UUID(), coordinate: .init(latitude: dto.latitude, longitude: dto.longitude))
    }
}

enum UserProfileMapper {
    static func toEntity(_ dto: UserProfileDTO) -> UserProfile { .init(name: dto.name, email: dto.email) }
    static func toDTO(_ entity: UserProfile) -> UserProfileDTO { .init(name: entity.name, email: entity.email) }
}
