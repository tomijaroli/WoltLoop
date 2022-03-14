//
//  RestaurantService.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine

struct Location {
    let latitude: Float
    let longitude: Float
}

protocol RestaurantService {
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<Result<[Section], Error>, Never>
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
    func searchRestaurantsNearby(location: Location) -> AnyPublisher<Result<[Section], Error>, Never> {
        networking.request(endpoint: .nearby(latitude: location.latitude, longitude: location.longitude))
            .map({ (result: Result<NearbyRestaurantsResponse, NetworkError>) -> Result<[Section], Error> in
                switch result {
                case .success(let nearbyRestaurantsResult): return .success(nearbyRestaurantsResult.sections)
                case .failure(let error): return .failure(error)
                }
            })
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
