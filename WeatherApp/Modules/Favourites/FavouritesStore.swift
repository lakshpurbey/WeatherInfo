import Foundation
import CoreLocation
import Combine
import SwiftUI

struct FavouriteLocationStore: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var latitude: Double
    var longitude: Double
    var addedDate: Date
    var lastWeatherUpdate: Date?
    var lastKnownWeatherSummary: String?

    init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, addedDate: Date = Date(), lastWeatherUpdate: Date? = nil, lastKnownWeatherSummary: String? = nil) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.addedDate = addedDate
        self.lastWeatherUpdate = lastWeatherUpdate
        self.lastKnownWeatherSummary = lastKnownWeatherSummary
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

@MainActor
final class FavouritesStoreViewModel: ObservableObject {
    @Published private(set) var favourites: [FavouriteLocationStore] = []

    private let saveURL: URL

    init(saveFileName: String = "favourites.json") {
        let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.saveURL = folder.appendingPathComponent(saveFileName)
        load()
    }

    func add(_ location: FavouriteLocationStore) {
        if !favourites.contains(location) {
            favourites.append(location)
            save()
        }
    }

    func remove(at offsets: IndexSet) {
        favourites.remove(atOffsets: offsets)
        save()
    }

    func remove(_ indexSet: IndexSet) { // convenience to match onDelete signature
        remove(at: indexSet)
    }

    func updateWeatherCache(for id: UUID, summary: String, updated: Date = Date()) {
        guard let idx = favourites.firstIndex(where: { $0.id == id }) else { return }
        favourites[idx].lastKnownWeatherSummary = summary
        favourites[idx].lastWeatherUpdate = updated
        save()
    }

    private func save() {
        do {
            let data = try JSONEncoder().encode(favourites)
            try data.write(to: saveURL, options: [.atomic])
        } catch {
            #if DEBUG
            print("Failed to save favourites: \(error)")
            #endif
        }
    }

    private func load() {
        do {
            let data = try Data(contentsOf: saveURL)
            favourites = try JSONDecoder().decode([FavouriteLocationStore].self, from: data)
        } catch {
            favourites = []
        }
    }
}
