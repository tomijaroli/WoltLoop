//
//  NearbyListView.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import SwiftUI

struct NearbyRestaurantsView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject var viewModel: NearbyRestaurantsViewModel
    @State var bootstrapped: Bool = false
    
    init(viewModel: NearbyRestaurantsViewModel) {
        self.viewModel = viewModel
        UITableView.appearance().separatorColor = .clear
    }
    
    var body: some View {
        VStack {
            NavigationView {
                VStack {
                    viewModel.errorMessage.map { message in
                        Text(message)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.secondary)
                            .animation(.default, value: message)
                    }
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
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                if !bootstrapped {
                    bootstrapped = true
                    return
                }
                viewModel.didEnterForeground()
            case .background:
                viewModel.didEnterBackground()
            case .inactive:
                fallthrough
            @unknown default:
                print("Breaking API changes has been introduced to ScenePhase")
            }
        }
    }
}

struct NearbyRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBuilder.shared.buildNearbyRestaurantsPreview()
    }
}
