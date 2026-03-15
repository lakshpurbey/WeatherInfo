//
//  ForecastRow.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import SwiftUI

struct ForecastRow: View {
    
    let item: ForecastItem

    var body: some View {
        HStack {
            
            Text(dayString)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: iconName)
                .foregroundColor(.white)
            
            Spacer()
            
            Text("\(Int(item.main.temp))°")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.vertical, 8)
    }
    }

// MARK: - Helpers

private extension ForecastRow {
    
    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: item.date)
    }
    
    var iconName: String {
        let condition = item.weather.first?.main.lowercased() ?? ""
        
        switch condition {
        case "clouds":
            return "cloud"
        case "rain":
            return "cloud.rain"
        case "clear":
            return "sun.max"
        default:
            return "cloud.sun"
        }
    }

}
