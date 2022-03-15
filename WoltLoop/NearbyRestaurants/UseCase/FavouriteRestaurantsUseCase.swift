//
//  FavouriteRestaurantsUseCase.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation

protocol FavouriteRestaurantsUseCase {
    func toggleFavourite(for restaurant: RestaurantViewModel)
    func decorateFavourites(restaurants: [RestaurantViewModel])
}

final class LiveFavouritesRestaurantsUseCase {
    @UserDefault(key: "favourite_restaurants", defaultValue: [])
    private var favourites: [String]
}

extension LiveFavouritesRestaurantsUseCase: FavouriteRestaurantsUseCase {
    func toggleFavourite(for restaurant: RestaurantViewModel) {
        if restaurant.isFavourite {
            favourites = favourites.filter { $0 != restaurant.id }
        } else {
            favourites.append(restaurant.id)
        }
        restaurant.isFavourite.toggle()
    }
    
    func decorateFavourites(restaurants: [RestaurantViewModel]) {
        restaurants.filter { favourites.contains($0.id) }.forEach { $0.isFavourite = true }
    }
}
