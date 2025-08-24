//
//  MenuViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

//
//  CoffeeMenuViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 19.04.2025.
//

import Foundation

@MainActor
final class CoffeeMenuViewModel: ObservableObject {
    @Published var menu: [CoffeeItem] = []
    @Published var isLoading = false
    @Published var error: String?

    private let fetchMenu: FetchMenuUseCase

    init(fetchMenu: FetchMenuUseCase) {
        self.fetchMenu = fetchMenu
    }

    func load() async {
        isLoading = true
        error = nil
        do {
            menu = try await fetchMenu.execute()
        } catch {
            self.error = "Не удалось загрузить меню"
        }
        isLoading = false
    }
}
