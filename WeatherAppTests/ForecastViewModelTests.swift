//
//  ForecastViewModelTests.swift
//  WeatherApp
//
//  Created by Laxmipurbey on 27/02/26.
//

import Testing
import CoreLocation
import Combine
@testable import WeatherApp

@MainActor
final class ForecastViewModelTests {

    final class TestableForecastViewModel: ObservableObject {
        @Published var dailyForecast: [ForecastItem] = []
        private let requestImpl: (URL) async throws -> ForecastResponse
        init(requestImpl: @escaping (URL) async throws -> ForecastResponse) {
            self.requestImpl = requestImpl
        }
        
        func fetchForecast(for location: CLLocation) async {
            guard let url = WeatherEndpoint.forecast(lat: location.coordinate.latitude, lon: location.coordinate.longitude) else { return }
            do {
                let response = try await requestImpl(url)
                dailyForecast = filterDailyForecast(response.list)
            } catch {
                dailyForecast = []
            }
        }
        
        func filterDailyForecast(_ list: [ForecastItem]) -> [ForecastItem] {
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = TimeZone(secondsFromGMT: 0)!

            let grouped = Dictionary(grouping: list) {
                calendar.startOfDay(for: $0.date)
            }
            
            let sorted = list.sorted { $0.date < $1.date }

            var result: [ForecastItem] = []
            var seenDays: Set<Date> = []

            for item in sorted {
                let day = calendar.startOfDay(for: item.date)
                if !seenDays.contains(day) {
                    seenDays.insert(day)
                    result.append(item)
                }
            }

            return Array(result.prefix(5))
        }
    }

    private func sampleForecastItems() -> [ForecastItem] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let components = DateComponents(
            calendar: calendar,
            timeZone: TimeZone(secondsFromGMT: 0),
            year: 2024,
            month: 1,
            day: 1,
            hour: 0
        )

        let base = calendar.date(from: components)!
        
        func makeItem(offsetHours: Int, temp: Double, condition: String) -> ForecastItem {
            ForecastItem(dt: base.addingTimeInterval(TimeInterval(3600 * offsetHours)).timeIntervalSince1970,
                         main: Main(temp: temp, temp_min: temp - 1, temp_max: temp + 1, humidity: 50, pressure: 1000),
                         weather: [Weather(main: condition)])
        }
        return [
            makeItem(offsetHours: 1, temp: 10, condition: "Clouds"),
            makeItem(offsetHours: 4, temp: 11, condition: "Clouds"),
            makeItem(offsetHours: 7, temp: 12, condition: "Rain"),
            makeItem(offsetHours: 25, temp: 15, condition: "Clear"),
            makeItem(offsetHours: 28, temp: 16, condition: "Clear")
        ]
    }

    @Test("Filters to one item per day, sorted, limited to 5")
    func filtersDaily() async throws {
        let items = sampleForecastItems()
        let vm = TestableForecastViewModel { _ in
            ForecastResponse(list: items)
        }
        let location = CLLocation(latitude: 0, longitude: 0)
        await vm.fetchForecast(for: location)
        #expect(vm.dailyForecast.count == 2)
        #expect(vm.dailyForecast.first?.main.temp == 10)
        #expect(vm.dailyForecast.last?.main.temp == 15)
    }

    @Test("Failure leaves empty list")
    func failure() async throws {
        let vm = TestableForecastViewModel { _ in
            struct E: Error {}; throw E()
        }
        let location = CLLocation(latitude: 0, longitude: 0)
        await vm.fetchForecast(for: location)
        #expect(vm.dailyForecast.isEmpty)
    }
}

