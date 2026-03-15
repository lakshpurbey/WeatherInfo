//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    
    @Published var temperature: String = "--"
    @Published var minTemp: String = "--"
    @Published var maxTemp: String = "--"
    @Published var condition: String = ""
    @Published var city: String = ""
    @Published var humidity: String = "--"
    @Published var pressure: String = "--"
    @Published var windSpeed: String = "--"
    
    private let network = NetworkManager()
    
    func fetchWeather(for location: CLLocation) async {
        guard let url = WeatherEndpoint.currentWeather(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude) else { return }
        
        do {
            let response: WeatherResponse =
            try await network.request(url)
                        
            temperature = "\(Int(response.main.temp))°"
            minTemp = "\(Int(response.main.temp_min))°"
            maxTemp = "\(Int(response.main.temp_max))°"
            condition = response.weather.first?.main ?? ""
            city = response.name
            
            humidity = "\(response.main.humidity)%"
                        pressure = "\(response.main.pressure) hPa"
                        windSpeed = "\(response.wind.speed) m/s"
            
        } catch {
            print("Error:", error)
        }
    }
}
