import SwiftUI
import CoreLocation

struct SearchResult: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.coordinate.latitude == rhs.coordinate.latitude &&
        lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct SearchView: View {
    @EnvironmentObject var store: FavouritesStoreViewModel
    @State private var query: String = ""
    @State private var results: [SearchResult] = []
    @State private var isSearching = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search places (Google Places)", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .submitLabel(.search)
                        .onSubmit { performSearch() }
                    if isSearching { ProgressView() }
                }
                .padding()

                List(results) { result in
                    VStack(alignment: .leading) {
                        Text(result.name).font(.headline)
                        Text("Lat: \(result.coordinate.latitude), Lon: \(result.coordinate.longitude)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        let fav = FavouriteLocationStore(name: result.name, latitude: result.coordinate.latitude, longitude: result.coordinate.longitude)
                        store.add(fav)
                    }
                }
                .overlay {
                    if results.isEmpty && !isSearching {
                        if #available(iOS 17.0, *) {
                            ContentUnavailableView("Search for a place", systemImage: "magnifyingglass", description: Text("Use the field above to search and tap a result to add it to favourites."))
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Search") { performSearch() }
                }
            }
        }
    }

    private func performSearch() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        isSearching = true
        // Mock search: generate a few coordinates based on hash of query
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.6) {
            let baseLat = Double(abs(trimmed.hashValue % 80)) - 40.0
            let baseLon = Double(abs(trimmed.hashValue % 160)) - 80.0
            let items = (0..<5).map { i -> SearchResult in
                let jitterLat = baseLat + Double(i) * 0.25
                let jitterLon = baseLon + Double(i) * 0.3
                return SearchResult(name: "\(trimmed) Place #\(i+1)", coordinate: CLLocationCoordinate2D(latitude: jitterLat, longitude: jitterLon))
            }
            DispatchQueue.main.async {
                self.results = items
                self.isSearching = false
            }
        }
    }
}
