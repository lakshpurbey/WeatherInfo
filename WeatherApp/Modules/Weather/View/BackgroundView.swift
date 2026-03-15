//
//  BackgroundView.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import SwiftUI

struct BackgroundView: View {
    
    let condition: String

    var body: some View {
        Image(backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
    }
    
    private var backgroundImage: String {
        switch condition.lowercased() {
        case "rain":
            return "forest_rainy"
        case "clouds":
            return "forest_cloudy"
        default:
            return "forest_sunny"
        }
    }

}
