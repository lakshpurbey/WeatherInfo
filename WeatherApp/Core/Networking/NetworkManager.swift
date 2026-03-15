//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import Foundation

final class NetworkManager {
    
    func request<T: Decodable>(_ url: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
