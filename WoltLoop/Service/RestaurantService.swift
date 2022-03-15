//
//  RestaurantService.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine

enum RestaruantServiceError: Error {
    case networkError
}

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

struct NearbyRestaurantsResponse: Codable {
    let pageTitle: String
    let sections: [Section]
}

struct Section: Codable {
    let items: [Restaurant]
}

struct Restaurant: Codable {
    let image: RestaurantImage
    let title: String
    let venue: Venue
}

struct RestaurantImage: Codable {
    let url: String
}

struct Venue: Codable {
    let address: String
    let currency: String
    let deliveryPrice: String
    let estimate: Int
    let id: String
    let location: [Float]
    let name: String
    let shortDescription: String?
}
