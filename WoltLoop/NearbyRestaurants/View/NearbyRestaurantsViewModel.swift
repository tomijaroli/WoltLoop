//
//  NearbyRestaurantsViewModel.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine

class NearbyRestaurantsViewModel: ObservableObject {
    @Published var pageTitle: String = "Restaurants"
    @Published var restaurants: [RestaurantViewModel] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private let nearbyRestaurantsUseCase: NearbyRestaurantsUseCase
    private let locationProvider: LocationProvider
    private let favouriteRestaurantsUseCase: FavouriteRestaurantsUseCase
    
    init(
        nearbyRestaurantsUseCase: NearbyRestaurantsUseCase,
        locationProvider: LocationProvider,
        favouriteRestaurantsUseCase: FavouriteRestaurantsUseCase
    ) {
        self.nearbyRestaurantsUseCase = nearbyRestaurantsUseCase
        self.locationProvider = locationProvider
        self.favouriteRestaurantsUseCase = favouriteRestaurantsUseCase
        
        locationProvider.locationPublisher.sink { [weak self] location in
            guard let self = self else { return }
            print("######## New location received on view model ########")
            nearbyRestaurantsUseCase.searchRestaurantsNearby(location: location)
                .receive(on: RunLoop.main)
                .sink { completion in
                    print(completion)
                    switch completion {
                    case .finished:
                        self.errorMessage = nil
                    case .failure:
                        self.errorMessage = "Oops! Something went wrong!"
                    }
                } receiveValue: { restaurants in
                    self.restaurants = restaurants
                    self.favouriteRestaurantsUseCase.decorateFavourites(restaurants: restaurants)
                    self.errorMessage = Int.random(in: 1..<100) % 3 == 0 ? "Oops! Something went wrong!" : nil
                }
                .store(in: &self.cancellables)
        }
        .store(in: &cancellables)
    }
    
    func markRestaurantFavourite(restaurant: RestaurantViewModel) {
        favouriteRestaurantsUseCase.toggleFavourite(for: restaurant)
    }
}
