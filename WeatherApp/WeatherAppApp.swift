//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    @StateObject private var store = FavouritesStoreViewModel()

    var body: some Scene {
        WindowGroup {
            
            TabView {
                WeatherView()
                    .tabItem { Label("Weather", systemImage: "sparkles") }
                SearchView()
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
                FavouritesView()
                    .tabItem { Label("Favourites", systemImage: "star.fill") }
                if #available(iOS 17.0, *) {
                    FavouritesMapView()
                        .tabItem { Label("Map", systemImage: "map") }
                } else {
                    // Fallback on earlier versions
                }
            }
            .environmentObject(store)
        }
    }
}
