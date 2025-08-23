//
//  TitleView.swift
//  CoffeDaily
//
//  Created by Aleksandr on 17.04.2025.
//

import SwiftUI

struct TitleView: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
    }
}
