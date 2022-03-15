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
    
    @UserDefault(key: "favourite_restaurants", defaultValue: [])
    private var favourites: [String]
    
    private var cancellables = Set<AnyCancellable>()
    
    private let nearbyRestaurantsUseCase: NearbyRestaurantsUseCase
    private let locationProvider: LocationProvider
    
    init(nearbyRestaurantsUseCase: NearbyRestaurantsUseCase, locationProvider: LocationProvider) {
        self.nearbyRestaurantsUseCase = nearbyRestaurantsUseCase
        self.locationProvider = locationProvider
        
        locationProvider.locationPublisher.sink { location in
            print("New location received: \(location)")
            nearbyRestaurantsUseCase.searchRestaurantsNearby(location: location)
                .receive(on: RunLoop.main)
                .sink { completion in
                    print(completion)
                } receiveValue: { [weak self] restaurants in
                    guard let self = self else { return }
                    print("######## Received restaurants ########")
                    print(restaurants)
                    self.restaurants = restaurants
                }
                .store(in: &self.cancellables)
        }
        .store(in: &cancellables)
    }
                                                         
//    private func searchNearbyRestaurants() {
//        serviceClient.searchRestaurantsNearby(
//            location: Location(
//                latitude: coordinates[currentCoordinateIndex].0,
//                longitude: coordinates[currentCoordinateIndex].1
//            )
//        )
//            .receive(on: RunLoop.main)
//            .prefix(15)
//            .sink { [weak self] result in
//                guard let self = self else { return }
//
//                switch result {
//                case .success(let sections):
//                    self.restaurants = self.mapResponseToRestaurantViewModels(sections: sections)
//                    self.restaurants.filter {
//                        self.favourites.contains($0.id)
//                    }
//                    .forEach {
//                        $0.isFavourite = true
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//            .store(in: &cancellables)
//    }
    
    func markRestaurantFavourite(restaurant: RestaurantViewModel) {
        print("Favourite pressed")
        if restaurant.isFavourite {
            favourites = favourites.filter { $0 != restaurant.id }
        } else {
            favourites.append(restaurant.id)
        }
        restaurant.isFavourite.toggle()
    }
}
