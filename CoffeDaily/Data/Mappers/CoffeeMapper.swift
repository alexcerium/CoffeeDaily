//
//  CoffeeMapper.swift
//  CoffeDaily
//
//  Created by Alex on 24.08.2025.
//

import Foundation

enum CoffeeMapper {
    static func map(_ dto: CoffeeDTO) -> CoffeeItem {
        CoffeeItem(
            id: dto.id ?? UUID(),
            imageName: dto.imageName,
            title: dto.title,
            description: dto.description,
            prices: dto.prices
        )
    }
}
