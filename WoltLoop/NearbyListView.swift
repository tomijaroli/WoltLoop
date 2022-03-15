//
//  NearbyListView.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import SwiftUI

struct NearbyListView: View {
    @StateObject var viewModel = NearbyListViewModel()
    
    init() {
        UITableView.appearance().separatorColor = .clear
    }
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    List(viewModel.restaurants) { restaurant in
                        NearbyRestaurantListItemView(
                            restaurantViewModel: restaurant,
                            markAsFavourite: viewModel.markRestaurantFavourite(restaurant:)
                        )
                            .padding(0)
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                }
                .navigationTitle("Restaurants")
            }
        }
    }
}

struct NearbyListView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyListView()
    }
}
