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
    private let logger: WoltLoopLogger
    
    init(
        nearbyRestaurantsUseCase: NearbyRestaurantsUseCase,
        locationProvider: LocationProvider,
        favouriteRestaurantsUseCase: FavouriteRestaurantsUseCase,
        logger: WoltLoopLogger
    ) {
        self.nearbyRestaurantsUseCase = nearbyRestaurantsUseCase
        self.locationProvider = locationProvider
        self.favouriteRestaurantsUseCase = favouriteRestaurantsUseCase
        self.logger = logger
        
        locationProvider.locationPublisher.sink { [weak self] location in
            guard let self = self else { return }
            
            self.logger.logDebug(message: "New location received on ViewModel")
            
            nearbyRestaurantsUseCase.searchRestaurantsNearby(location: location)
                .receive(on: RunLoop.main)
                .sink { completion in
                    print(completion)
                    switch completion {
                    case .finished:
                        self.errorMessage = nil
                    case .failure(let error):
                        let errorMessage = "Oops! Something went wrong!"
                        self.errorMessage = errorMessage
                        self.logger.logError(message: errorMessage, error: error)
                    }
                } receiveValue: { restaurants in
                    self.restaurants = restaurants
                    self.favouriteRestaurantsUseCase.decorateFavourites(restaurants: restaurants)
                    self.errorMessage = nil
                    self.logger.logDebug(message: "Restaurants received on ViewModel")
                }
                .store(in: &self.cancellables)
        }
        .store(in: &cancellables)
    }
    
    func markRestaurantFavourite(restaurant: RestaurantViewModel) {
        logger.logDebug(message: "Toggle restaurant with id: \(restaurant.id) favourite")
        favouriteRestaurantsUseCase.toggleFavourite(for: restaurant)
    }
    
    func didEnterForeground() {
        logger.logDebug(message: "Did enter foreground.")
        locationProvider.resume()
    }
    
    func didEnterBackground() {
        logger.logDebug(message: "Did enter background.")
        locationProvider.pause()
    }
}
