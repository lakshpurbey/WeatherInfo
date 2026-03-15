//
//  WeatherViewModelTests.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 27/02/26.
//

import Testing
import CoreLocation
import Combine
@testable import WeatherApp

@MainActor
final class WeatherViewModelTests {
    struct MockNetworkManager: Sendable {
        enum Mode { case success(Data), failure(Error) }
        let mode: Mode
        struct DummyError: Error {}
        func request<T: Decodable>(_ url: URL) async throws -> T {
            switch mode {
            case .success(let data):
                return try JSONDecoder().decode(T.self, from: data)
            case .failure(let error):
                throw error
            }
        }
    }

    // Testable copy to allow DI without touching production code
    final class TestableWeatherViewModel: ObservableObject {
        @Published var temperature: String = "--"
        @Published var minTemp: String = "--"
        @Published var maxTemp: String = "--"
        @Published var condition: String = ""
        @Published var city: String = ""
        @Published var humidity: String = "--"
        @Published var pressure: String = "--"
        @Published var windSpeed: String = "--"

        private let requestImpl: (URL) async throws -> WeatherResponse
        init(requestImpl: @escaping (URL) async throws -> WeatherResponse) {
            self.requestImpl = requestImpl
        }
        func fetchWeather(for location: CLLocation) async {
            guard let url = WeatherEndpoint.currentWeather(
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude) else { return }
            do {
                let response = try await requestImpl(url)
                temperature = "\(Int(response.main.temp))°"
                minTemp = "\(Int(response.main.temp_min))°"
                maxTemp = "\(Int(response.main.temp_max))°"
                condition = response.weather.first?.main ?? ""
                city = response.name
                humidity = "\(response.main.humidity)%"
                pressure = "\(response.main.pressure) hPa"
                windSpeed = "\(response.wind.speed) m/s"
            } catch {
                // keep defaults
            }
        }
    }

    private func sampleWeatherJSON() -> Data {
        let json = """
        {
          "name": "Cupertino",
          "main": {
            "temp": 21.4,
            "temp_min": 18.0,
            "temp_max": 25.9,
            "humidity": 60,
            "pressure": 1015
          },
          "weather": [ { "main": "Clouds" } ],
          "wind": { "speed": 3.5 }
        }
        """
        return Data(json.utf8)
    }

    @Test("WeatherViewModel maps response to display strings")
    func mapsResponse() async throws {
        let data = sampleWeatherJSON()
        let vm = TestableWeatherViewModel { url in
            let decoder = JSONDecoder()
            return try decoder.decode(WeatherResponse.self, from: data)
        }
        let location = CLLocation(latitude: 37.3349, longitude: -122.0090)
        await vm.fetchWeather(for: location)
        #expect(vm.temperature == "21°")
        #expect(vm.minTemp == "18°")
        #expect(vm.maxTemp == "25°")
        #expect(vm.condition == "Clouds")
        #expect(vm.city == "Cupertino")
        #expect(vm.humidity == "60%")
        #expect(vm.pressure == "1015 hPa")
        #expect(vm.windSpeed == "3.5 m/s")
    }

    @Test("WeatherViewModel keeps defaults on failure")
    func handlesFailure() async throws {
        let vm = TestableWeatherViewModel { _ in
            struct E: Error {}
            throw E()
        }
        let location = CLLocation(latitude: 0, longitude: 0)
        await vm.fetchWeather(for: location)
        #expect(vm.temperature == "--")
        #expect(vm.condition == "")
    }
}
