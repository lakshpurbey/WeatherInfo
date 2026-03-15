//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Decodable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Int
    let pressure: Int
}

struct Weather: Decodable {
    let main: String
}

struct Wind: Decodable {
    let speed: Double
}
