//
//  RestaurantService.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine

/// @mockable
protocol RestaurantService {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<[Section], RestaruantServiceError>
}

class RestaurantServiceClient {
    private let networking: NetworkProvider<RestaurantsEndpoint>
    private let logger: WoltLoopLogger
    
    init(networking: NetworkProvider<RestaurantsEndpoint>, logger: WoltLoopLogger) {
        self.networking = networking
        self.logger = logger
    }
}

extension RestaurantServiceClient: RestaurantService {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<[Section], RestaruantServiceError> {
        networking.request(endpoint: .nearby(latitude: location.latitude, longitude: location.longitude))
            .mapError { [weak self] networkError in
                self?.logger.logError(
                    message: "\(#function) received \(networkError), mapped to: RestaurantServiceError", error: networkError
                )
                return RestaruantServiceError.networkError
            }
            .map { [weak self] (result: NearbyRestaurantsResponse) in
                self?.logger.logDebug(message: "\(#function) received response result.")
                return result.sections
            }
            .subscribe(on: RunLoop.main)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
