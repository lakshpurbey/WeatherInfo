//
//  ModelDecodingTests.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 27/02/26.
//

import Testing
@testable import WeatherApp
import Foundation

struct ModelDecodingTests {
    @Test("Decodes WeatherResponse")
    func decodeWeather() throws {
        let json = """
        {
          "name": "Paris",
          "main": {"temp": 19.2, "temp_min": 17.0, "temp_max": 22.0, "humidity": 55, "pressure": 1012},
          "weather": [ { "main": "Rain" } ],
          "wind": { "speed": 5.2 }
        }
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
        #expect(decoded.name == "Paris")
        #expect(decoded.main.temp == 19.2)
        #expect(decoded.weather.first?.main == "Rain")
        #expect(decoded.wind.speed == 5.2)
    }

    @Test("Decodes ForecastResponse and derives date")
    func decodeForecast() throws {
        let dt: TimeInterval = 1_700_000_000
        let json = """
        { "list": [
          { "dt": \(Int(dt)),
            "main": {"temp": 10.5, "temp_min": 9.0, "temp_max": 12.0, "humidity": 40, "pressure": 1008},
            "weather": [ { "main": "Clear" } ]
          }
        ]}
        """
        let data = Data(json.utf8)
        let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
        #expect(decoded.list.count == 1)
        let item = try #require(decoded.list.first)
        #expect(Int(item.dt) == Int(dt))
        #expect(Calendar.current.isDateInToday(item.date) == false)
        #expect(item.weather.first?.main == "Clear")
    }
}
