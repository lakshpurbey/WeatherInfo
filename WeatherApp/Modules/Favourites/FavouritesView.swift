//
//  FavouritesView.swift
//  WeatherApp
//
//  Created by Laxmipurbey on 24/02/26.
//

import SwiftUI

struct FavouritesView: View {
    
    @EnvironmentObject var store: FavouritesStoreViewModel

    var body: some View {
        NavigationStack {
                    List {
                        ForEach(store.favourites) { location in
                            NavigationLink {
                                WeatherDetailView(location: location)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(location.name)
                                        .font(.headline)
                                    
                                    Text("Added: \(location.addedDate.formatted())")
                                        .font(.caption)
                                }
                            }
                        }
                        .onDelete(perform: store.remove(at:))
                    }
                    .navigationTitle("Favourites")
                    .toolbar {
                        ToolbarItemGroup(placement: .topBarTrailing) {
                            NavigationLink(destination: SearchView()) {
                                Image(systemName: "plus")
                            }
                            if #available(iOS 17.0, *) {
                                NavigationLink(destination: FavouritesMapView()) {
                                    Image(systemName: "map")
                                }
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }
                }
    }
}
