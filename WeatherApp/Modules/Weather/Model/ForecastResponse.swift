//
//  ForecastResponse.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [ForecastItem]
}

struct ForecastItem: Decodable, Identifiable {
    let id = UUID()
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
    
    var date: Date {
        Date(timeIntervalSince1970: dt)
    }
}
