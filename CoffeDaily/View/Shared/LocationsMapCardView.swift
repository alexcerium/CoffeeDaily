//
//  LocationsMapCardView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

import SwiftUI
import MapKit

struct LocationsMapCardView: View {
    @Binding var region: MKCoordinateRegion
    let locations: [CoffeeLocation]

    var body: some View {
        GlassCard {
            Map(coordinateRegion: $region, annotationItems: locations) { loc in
                MapMarker(coordinate: loc.coordinate, tint: .red)
            }
            .frame(height: 180)   
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }
}
