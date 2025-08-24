//
//  CoffeeMapper.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

// Data/Mappers/CoffeeMapper.swift
import Foundation

enum CoffeeMapper {
    static func map(_ dto: CoffeeDTO) -> CoffeeItem {
        let uuid = dto.id.flatMap { UUID(uuidString: $0) } ?? UUID()
        return CoffeeItem(
            id: uuid,
            imageName: dto.imageName,
            title: dto.title,
            description: dto.description,
            prices: dto.prices
        )
    }
}
