//
//  NearbyRestaurantsUseCase.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation
import Combine

/// @mockable
protocol NearbyRestaurantsUseCase {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<[RestaurantViewModel], Error>
}

final class LiveNearbyRestaurantsUseCase {
    private let restaurantsService: RestaurantService
    private let logger: WoltLoopLogger
    private var cancellables = Set<AnyCancellable>()
    
    init(restaurantsService: RestaurantService, logger: WoltLoopLogger) {
        self.restaurantsService = restaurantsService
        self.logger = logger
    }
}

extension LiveNearbyRestaurantsUseCase: NearbyRestaurantsUseCase {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<[RestaurantViewModel], Error> {
        restaurantsService.searchRestaurantsNearby(location: location)
            .mapError { [weak self] error in
                self?.logger.logError(message: error.localizedDescription, error: error)
                return error // TODO: map error properly
            }
            .map { result in
                result[0].items.prefix(15).map { restaurant in
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
