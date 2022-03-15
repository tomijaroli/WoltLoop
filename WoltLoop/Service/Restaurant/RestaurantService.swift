//
//  RestaurantService.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine

protocol RestaurantService {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<[Section], RestaruantServiceError>
}

class RestaurantServiceClient {
    private let networking: NetworkProvider<RestaurantsEndpoint>
    //    private let scheduler: SchedulerProtocol
    
    init(
        networking: NetworkProvider<RestaurantsEndpoint> = NetworkProvider()
        //        scheduler: SchedulerProtocol = Scheduler()
    ) {
        self.networking = networking
        //        self.scheduler = scheduler
    }
}

extension RestaurantServiceClient: RestaurantService {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<[Section], RestaruantServiceError> {
        networking.request(endpoint: .nearby(latitude: location.latitude, longitude: location.longitude))
            .mapError { networkError in
                RestaruantServiceError.networkError
            }
            .map { (result: NearbyRestaurantsResponse) in
                result.sections
            }
            .subscribe(on: RunLoop.main)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
