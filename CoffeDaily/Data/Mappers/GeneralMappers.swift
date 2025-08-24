//
//  GeneralMappers.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation
import CoreLocation

enum CartMapper {
    static func toEntity(_ dto: CartItemDTO, resolve: (UUID) -> CoffeeItem?) -> CartItem? {
        guard let item = resolve(dto.itemId) else { return nil }
        return CartItem(item: item, size: dto.size, quantity: dto.qty)
    }
    static func toDTO(_ entity: CartItem) -> CartItemDTO {
        .init(itemId: entity.item.id, size: entity.size, qty: entity.quantity)
    }
}

enum OrderMapper {
    static func toEntity(_ dto: OrderDTO, resolve: (UUID) -> CoffeeItem?) -> Order? {
        let items: [CartItem] = dto.items.compactMap { CartMapper.toEntity($0, resolve: resolve) }
        return Order(id: dto.id, date: dto.date, items: items)
    }
    static func toDTO(_ entity: Order) -> OrderDTO {
        .init(id: entity.id, date: entity.date, items: entity.items.map(CartMapper.toDTO(_:)))
    }
}

enum NotificationMapper {
    static func toEntity(_ dto: NotificationDTO) -> NotificationItem {
        NotificationItem(id: dto.id, title: dto.title, message: dto.message, date: dto.date)
    }
}

enum LocationMapper {
    static func toEntity(_ dto: LocationDTO) -> CoffeeLocation {
        CoffeeLocation(id: dto.id, coordinate: CLLocationCoordinate2D(latitude: dto.latitude, longitude: dto.longitude))
    }
}

enum UserProfileMapper {
    static func toEntity(_ dto: UserProfileDTO) -> UserProfile { .init(name: dto.name, email: dto.email) }
    static func toDTO(_ entity: UserProfile) -> UserProfileDTO { .init(name: entity.name, email: entity.email) }
}
