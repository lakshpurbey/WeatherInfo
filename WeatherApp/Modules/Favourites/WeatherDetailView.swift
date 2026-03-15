import SwiftUI
import CoreLocation

struct WeatherDetailView: View {
    let location: FavouriteLocationStore
    @EnvironmentObject var store: FavouritesStoreViewModel
    @State private var isLoading = false
    @State private var currentSummary: String?

    var body: some View {
        List {
            Section("Overview") {
                LabeledContent("Name", value: location.name)
                LabeledContent("Coordinates", value: String(format: "%.4f, %.4f", location.latitude, location.longitude))
                LabeledContent("Added", value: location.addedDate.formatted(date: .abbreviated, time: .shortened))
            }
            Section("Weather") {
                if let summary = currentSummary ?? location.lastKnownWeatherSummary {
                    Text(summary)
                } else {
                    Text("No weather available. Pull to refresh.").foregroundStyle(.secondary)
                }
                if let updated = location.lastWeatherUpdate {
                    LabeledContent("Last updated", value: updated.formatted(date: .abbreviated, time: .shortened))
                }
            }
            Section("Extra Info") {
                if let updated = location.lastWeatherUpdate {
                    LabeledContent("Last updated", value: updated.formatted(date: .abbreviated, time: .shortened))
                } else {
                    Text("No update info available").foregroundStyle(.secondary)
                }
                Button(action: {
                    Task {
                        await refreshWeather()
                    }
                }) {
                    HStack {
                        Text("Refresh Weather")
                        if isLoading {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
                .disabled(isLoading)
            }
        }
        .refreshable { await refreshWeather() }
        .navigationTitle(location.name)
        .toolbar { if isLoading { ProgressView() } }
        .task { currentSummary = location.lastKnownWeatherSummary }
    }

    private func refreshWeather() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }
        // Mock network fetch: create a synthetic weather summary
        try? await Task.sleep(nanoseconds: 800_000_000)
        let temp = Int.random(in: -10...38)
        let conditions = ["Sunny", "Cloudy", "Rain", "Windy", "Snow"].randomElement()!
        let summary = "\(conditions), \(temp)°C"
        currentSummary = summary
        store.updateWeatherCache(for: location.id, summary: summary, updated: Date())
    }
}

#Preview {
    WeatherDetailView(location: FavouriteLocationStore(name: "Cape Town", latitude: -33.9249, longitude: 18.4241, lastWeatherUpdate: .now, lastKnownWeatherSummary: "Sunny, 26°C")).environmentObject(FavouritesStoreViewModel())
}
