//
//  NearbyRestaurantsUseCase.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation
import Combine

protocol NearbyRestaurantsUseCase {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<[RestaurantViewModel], Error>
}

final class LiveNearbyRestaurantsUseCase {
    private let restaurantsServiceClient: RestaurantServiceClient
    private var cancellables = Set<AnyCancellable>()
    
    init(restaurantsServiceClient: RestaurantServiceClient) {
        self.restaurantsServiceClient = restaurantsServiceClient
    }
}

extension LiveNearbyRestaurantsUseCase: NearbyRestaurantsUseCase {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<[RestaurantViewModel], Error> {
        restaurantsServiceClient.searchRestaurantsNearby(location: location)
            .mapError { error in error } // TODO: map error properly
            .map { result in
                result[0].items[...14].map { restaurant in
                    RestaurantViewModel(
                        id: restaurant.venue.id,
                        name: restaurant.venue.name,
                        shortDescription: restaurant.venue.shortDescription,
                        imageUrl: restaurant.image.url,
                        isFavourite: false
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}
