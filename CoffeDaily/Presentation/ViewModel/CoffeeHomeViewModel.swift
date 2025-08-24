//
//  HomeViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

import Foundation
import MapKit

final class CoffeeHomeViewModel: ObservableObject {
    private let fetchLocations: FetchLocationsUseCase
    init(fetchLocations: FetchLocationsUseCase) {
        self.fetchLocations = fetchLocations
    }

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.1699, longitude: 24.9384),
        span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
    )
    @Published var locations: [CoffeeLocation] = []

    @MainActor func load() async {
        if let list = try? await fetchLocations.execute() { self.locations = list }
    }
}
