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
    let shortDescription: String
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

final class NearbyListViewModel: ObservableObject {
    @Published var restaurants: [RestaurantViewModel]
    
    private let serviceClient = RestaurantServiceClient()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.restaurants =  mockRestaurants

        self.serviceClient.searchRestaurantsNearby(location: Location(latitude: 60.170187, longitude: 24.930599))
            .receive(on: RunLoop.main)
            .prefix(15)
            .sink { result in
                switch result {
                case .success(let sections):
                    sections.forEach { section in
                        section.items[...14].forEach { restaurant in
                            print("#################################")
                            print(restaurant)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }
}
