//
//  FavouriteRestaurantsUseCase.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation

/// @mockable
protocol FavouriteRestaurantsUseCase {
    func toggleFavourite(for restaurant: RestaurantViewModel)
    func decorateFavourites(restaurants: [RestaurantViewModel])
}

final class LiveFavouriteRestaurantsUseCase {
    @UserDefault(key: "favourite_restaurants", defaultValue: [])
    internal var favourites: [String]
}

extension LiveFavouriteRestaurantsUseCase: FavouriteRestaurantsUseCase {
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
