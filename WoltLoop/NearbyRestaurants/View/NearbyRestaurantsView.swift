//
//  NearbyListView.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import SwiftUI

struct NearbyRestaurantsView: View {
    @ObservedObject var viewModel: NearbyRestaurantsViewModel
    
    init(viewModel: NearbyRestaurantsViewModel) {
        self.viewModel = viewModel
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
                            .accessibilityLabel(restaurant.name)
                            .padding(0)
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.hidden)
                    .animation(.default, value: viewModel.restaurants)
                    .accessibilityLabel(viewModel.pageTitle)
                }
                .navigationTitle(viewModel.pageTitle)
            }
        }
    }
}

struct NearbyRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBuilder.shared.buildNearbyRestaurantsPreview()
    }
}
