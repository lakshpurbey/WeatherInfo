//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 24/02/26.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var forecastVM = ForecastViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView(condition: viewModel.condition)
            
            VStack(spacing: 10) {
                
                Text(viewModel.temperature)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(.white)
                
                Text(viewModel.condition.uppercased())
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                HStack {
                    VStack {
                        Text(viewModel.minTemp)
                        Text("min")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(viewModel.maxTemp)
                        Text("max")
                    }
                }
                .foregroundColor(.white)
                .padding()
                
                Divider().background(Color.white)
                
                ForecastListView(viewModel: forecastVM)
            }
            .padding()
        }
        .onChange(of: locationManager.location) { location in
            guard let location = location else { return }
            
            Task {
                await viewModel.fetchWeather(for: location)
                await forecastVM.fetchForecast(for: location)
            }
        }
    }
}

#Preview {
    WeatherView()
}
