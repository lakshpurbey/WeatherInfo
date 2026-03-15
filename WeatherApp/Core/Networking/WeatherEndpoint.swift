//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import Foundation

enum WeatherEndpoint {
    
    static let apiKey = "74c67935195afe2480634cb63e39e358"
    
    static func currentWeather(lat: Double, lon: Double) -> URL? {
        let urlString =
        "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        return URL(string: urlString)
    }
    
    static func forecast(lat: Double, lon: Double) -> URL? {
        let urlString =
        "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        return URL(string: urlString)
    }
}
