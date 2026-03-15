//
//  ForecastListView.swift
//  WeatherApp
//
//  Created by Lakshpurbey on 25/02/26.
//

import SwiftUI

struct ForecastListView: View {
    @ObservedObject var viewModel: ForecastViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.dailyForecast) { item in
                ForecastRow(item: item)
            }
        }
    }

}
