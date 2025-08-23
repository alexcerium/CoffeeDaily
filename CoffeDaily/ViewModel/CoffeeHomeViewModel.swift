//
//  HomeViewModel.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

import Foundation
import MapKit

final class CoffeeHomeViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 60.1699, longitude: 24.9384),
        span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
    )
    @Published var locations: [CoffeeLocation] = [
        .init(coordinate: .init(latitude: 60.1686, longitude: 24.9398)),
        .init(coordinate: .init(latitude: 60.1625, longitude: 24.9450)),
        .init(coordinate: .init(latitude: 60.1712, longitude: 24.9230)),
        .init(coordinate: .init(latitude: 60.1790, longitude: 24.9302))
    ]
}
