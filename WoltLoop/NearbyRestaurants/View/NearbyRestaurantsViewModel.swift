//
//  NearbyRestaurantsViewModel.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine

final class NearbyRestaurantsViewModel: ObservableObject {
    @Published var restaurants: [RestaurantViewModel] = []
    
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
        
        locationProvider.locationPublisher.sink { location in
            nearbyRestaurantsUseCase.searchRestaurantsNearby(location: location)
                .receive(on: RunLoop.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { [weak self] restaurants in
                    guard let self = self else { return }
                    self.restaurants = restaurants
                    self.favouriteRestaurantsUseCase.decorateFavourites(restaurants: restaurants)
                }
                .store(in: &self.cancellables)
        }
        .store(in: &cancellables)
    }
    
    func markRestaurantFavourite(restaurant: RestaurantViewModel) {
        favouriteRestaurantsUseCase.toggleFavourite(for: restaurant)
    }
}
