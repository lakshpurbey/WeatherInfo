//
//  ForecastViewModel.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 25/02/26.
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class ForecastViewModel: ObservableObject {
    
    @Published var dailyForecast: [ForecastItem] = []
    
    private let network = NetworkManager()
    
    func fetchForecast(for location: CLLocation) async {
        
        guard let url = WeatherEndpoint.forecast(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        ) else { return }
        
        do {
            let response: ForecastResponse =
            try await network.request(url)
                        
            dailyForecast = filterDailyForecast(response.list)
            
        } catch {
            print("Forecast error:", error)
        }
    }
    
    // Filter to one item per day (around 12:00)
    private func filterDailyForecast(_ list: [ForecastItem]) -> [ForecastItem] {
        
        let grouped = Dictionary(grouping: list) {
            Calendar.current.startOfDay(for: $0.date)
        }
        
        return grouped.compactMap { $0.value.first }
            .sorted { $0.date < $1.date }
            .prefix(5)
            .map { $0 }
    }
}
