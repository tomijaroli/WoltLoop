//
//  NearbyRestaurantsViewModel.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: RestaurantViewModel, rhs: RestaurantViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    let id: String
    let name: String
    let shortDescription: String?
    var imageUrl: URL?
    @Published var isFavourite: Bool
    
    init(id: String, name: String, shortDescription: String?, imageUrl: String?, isFavourite: Bool) {
        self.id = id
        self.name = name
        self.shortDescription = shortDescription
        self.isFavourite = isFavourite
        
        if let imageUrlString = imageUrl, !imageUrlString.isEmpty {
            self.imageUrl = URL(string: imageUrlString)
        }
    }
}

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

final class NearbyRestaurantsViewModel: ObservableObject {
    @Published var restaurants: [RestaurantViewModel]
    
    @UserDefault(key: "favourite_restaurants", defaultValue: [])
    private var favourites: [String]
    
    private let serviceClient = RestaurantServiceClient()
    private var cancellables = Set<AnyCancellable>()
    
    private var currentCoordinateIndex = 0 {
        didSet {
            searchNearbyRestaurants()
        }
    }
    private var timer: Timer?
    
    private let nearbyRestaurantsUseCase: NearbyRestaurantsUseCase
    
    init(nearbyRestaurantsUseCase: NearbyRestaurantsUseCase) {
        self.restaurants =  mockRestaurants
        self.nearbyRestaurantsUseCase = nearbyRestaurantsUseCase
        searchNearbyRestaurants()
        startRotating()
    }
    
    func startRotating() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.rotateCoordinates()
        }
    }
    
    private func searchNearbyRestaurants() {
        nearbyRestaurantsUseCase.searchRestaurantsNearby(location: Location(latitude: coordinates[currentCoordinateIndex].0,
                                                                            longitude: coordinates[currentCoordinateIndex].1))
            .receive(on: RunLoop.main)
            .sink { completion in
                print(completion)
            } receiveValue: { [weak self] restaurants in
                guard let self = self else { return }
                self.restaurants = restaurants
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
    
    @objc
    private func rotateCoordinates() {
        if currentCoordinateIndex + 1 == coordinates.count {
            currentCoordinateIndex = 0
        } else {
            currentCoordinateIndex += 1
        }
    }
}
