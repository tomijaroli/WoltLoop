//
//  FavouriteRestaurantsUseCase.swift
//  WoltLoopTests
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import XCTest
@testable import WoltLoop

class FavouriteRestaurantsUseCaseTests: XCTestCase {
    private var useCase: LiveFavouriteRestaurantsUseCase!
    
    override func tearDown() {
        useCase.favourites = []
    }
    
    func test_givenNonFavouriteRestaurant_whenToggleFavouriteCalled_thenItIsMarkedAsFavouriteAndPersisted() {
        // Given
        let restaurant = makeRestaurant(id: 1)
        useCase = makeUseCase()
        
        // When
        useCase.toggleFavourite(for: restaurant)
        
        // Then
        XCTAssertTrue(restaurant.isFavourite)
        XCTAssertTrue(useCase.favourites.contains(restaurant.id))
    }
    
    func test_givenFavouriteRestaurant_whenToggleFavouriteCalled_thenItIsRemovedFromFavourites() {
        // Given
        let restaurant = makeRestaurant(id: 1, isFavourite: true)
        useCase = makeUseCase()
        
        // When
        useCase.toggleFavourite(for: restaurant)
        
        // Then
        XCTAssertFalse(restaurant.isFavourite)
        XCTAssertFalse(useCase.favourites.contains(restaurant.id))
    }
    
    func test_givenMarkedAndNonMarkedRestaurants_whenDecorateFavouritesCalled_thenMarkedRestaurantsAreDecorated() {
        // Given
        let favouriteRestaurants = (1..<10).map { makeRestaurant(id: $0) }
        let nonFavouriteRestaurants = (1..<10).map { makeRestaurant(id: $0 + 10) }
        let restaurants = favouriteRestaurants + nonFavouriteRestaurants
        
        useCase = makeUseCase()
        useCase.favourites = favouriteRestaurants.map { $0.id }
        
        // When
        useCase.decorateFavourites(restaurants: restaurants)
        
        // Then
        favouriteRestaurants.forEach { restaurant in
            XCTAssertTrue(restaurant.isFavourite)
        }
        nonFavouriteRestaurants.forEach { restaurant in
            XCTAssertFalse(restaurant.isFavourite)
        }
    }
    
    private func makeUseCase() -> LiveFavouriteRestaurantsUseCase {
        LiveFavouriteRestaurantsUseCase()
    }
    
    private func makeRestaurant(id: Int, isFavourite: Bool = false) -> RestaurantViewModel {
        .init(id: String(id), name: "name", shortDescription: "description", imageUrl: nil, isFavourite: isFavourite)
    }
}
