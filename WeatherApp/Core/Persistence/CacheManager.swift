//
//  CacheManager.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import Foundation

final class CacheManager {
    
    static func save<T: Encodable>(_ object: T, key: String) {
        let data = try? JSONEncoder().encode(object)
        UserDefaults.standard.set(data, forKey: key)
    }
    
    static func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
