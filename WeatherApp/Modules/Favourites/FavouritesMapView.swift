import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct FavouritesMapView: View {
    @EnvironmentObject var store: FavouritesStoreViewModel
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        NavigationStack {
            Map(position: $position) {
                ForEach(store.favourites) { fav in
                    Annotation(fav.name, coordinate: fav.coordinate) {
                        ZStack {
                            Circle().fill(.blue.opacity(0.8)).frame(width: 28, height: 28)
                            Text(String(fav.name.prefix(1))).font(.caption).bold().foregroundStyle(.white)
                        }
                    }
                }
            }
            .mapStyle(.standard)
            .onAppear { fitAll() }
            .navigationTitle("Map")
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Fit") { fitAll() } } }
        }
    }

    private func fitAll() {
        guard !store.favourites.isEmpty else { return }
        let coords = store.favourites.map { $0.coordinate }
        var region = MKCoordinateRegion()
        var minLat = coords.first!.latitude
        var maxLat = coords.first!.latitude
        var minLon = coords.first!.longitude
        var maxLon = coords.first!.longitude
        for c in coords.dropFirst() {
            minLat = min(minLat, c.latitude)
            maxLat = max(maxLat, c.latitude)
            minLon = min(minLon, c.longitude)
            maxLon = max(maxLon, c.longitude)
        }
        let span = MKCoordinateSpan(latitudeDelta: max(0.2, (maxLat - minLat) * 1.5), longitudeDelta: max(0.2, (maxLon - minLon) * 1.5))
        region.center = CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLon + maxLon)/2)
        region.span = span
        position = .region(region)
    }
}
