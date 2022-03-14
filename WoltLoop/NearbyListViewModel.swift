//
//  NearbyListViewModel.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine

struct RestaurantViewModel: Identifiable {
    let id = UUID()
    let name: String
    let shortDescription: String?
    let imageUrl: String?
    var isFavourite: Bool
}

let mockRestaurants = [
    RestaurantViewModel(name: "McDonald's", shortDescription: "I'm lovin it", imageUrl: nil, isFavourite: false),
    RestaurantViewModel(name: "Burger King", shortDescription: "I'm lovin it", imageUrl: nil, isFavourite: false),
    RestaurantViewModel(name: "Kolme Kruunua", shortDescription: "I'm lovin it", imageUrl: nil, isFavourite: false),
    RestaurantViewModel(name: "KFC", shortDescription: "I'm lovin it", imageUrl: nil, isFavourite: false),
    RestaurantViewModel(name: "Sushi Bar", shortDescription: "I'm lovin it", imageUrl: nil, isFavourite: false),
    RestaurantViewModel(name: "Fat Ramen Kallio", shortDescription: "I'm lovin it", imageUrl: nil, isFavourite: false)
]

let coordinates = [
    (60.170187, 24.930599),
    (60.169418, 24.931618),
    (60.169818, 24.932906),
    (60.170005, 24.935105),
    (60.169108, 24.936210),
    (60.168355, 24.934869),
    (60.167560, 24.932562),
    (60.168254, 24.931532),
    (60.169012, 24.930341),
    (60.170085, 24.929569)
]

final class NearbyListViewModel: ObservableObject {
    @Published var restaurants: [RestaurantViewModel]
    
    private let serviceClient = RestaurantServiceClient()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentCoordinateIndex = 0 {
        didSet {
            searchNearbyRestaurants()
        }
    }
    private var timer: Timer?
    
    init() {
        self.restaurants =  mockRestaurants
    }
    
    func startRotating() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.rotateCoordinates()
        }
    }
    
    private func searchNearbyRestaurants() {
        serviceClient.searchRestaurantsNearby(
            location: Location(
                latitude: coordinates[currentCoordinateIndex].0,
                longitude: coordinates[currentCoordinateIndex].1
            )
        )
            .receive(on: RunLoop.main)
            .prefix(15)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let sections):
                    self.restaurants = self.mapResponseToRestaurantViewModels(sections: sections)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
    
    @objc
    private func rotateCoordinates() {
        if currentCoordinateIndex + 1 == coordinates.count {
            currentCoordinateIndex = 0
        } else {
            currentCoordinateIndex += 1
        }
    }
    
    private func mapResponseToRestaurantViewModels(sections: [Section]) -> [RestaurantViewModel] {
        let restaurants = sections[0].items[...14]
        let viewModels = restaurants.map { restaurant in
            RestaurantViewModel(
                name: restaurant.venue.name,
                shortDescription: restaurant.venue.shortDescription,
                imageUrl: restaurant.image.url,
                isFavourite: false
            )
        }
        return viewModels
    }
}
