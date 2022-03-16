//
//  NearbyRestaurantsUseCaseTests.swift
//  WoltLoopTests
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import XCTest
import Combine
@testable import WoltLoop

class NearbyRestaurantsUseCaseTests: XCTestCase {
    private var useCase: NearbyRestaurantsUseCase!
    private var mockRestaurantService: RestaurantServiceMock!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        mockRestaurantService = RestaurantServiceMock()
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables = Set<AnyCancellable>()
    }
    
    func test_givenRestaurantServiceReturnsSuccesfully_whenSearchingRestaurantsNearbyForLocation_thenReturn15RestaurantViewModels() {
        // Given
        let sections = createDummySections()
        mockRestaurantService.searchRestaurantsNearbyHandler = { _ in
            Just(sections).setFailureType(to: RestaruantServiceError.self).eraseToAnyPublisher()
        }
        useCase = makeUseCase()
        
        var restaurantCount = 0
        var isRestaurantArray = false
        
        // When
        useCase.searchRestaurantsNearby(location: Location(latitude: 0, longitude: 0))
            .sink { _ in } receiveValue: { restaurants in
                restaurantCount = restaurants.count
                isRestaurantArray = (restaurants as Any) is [RestaurantViewModel]
            }
            .store(in: &cancellables)

        // Then
        XCTAssertEqual(restaurantCount, 15)
        XCTAssertTrue(isRestaurantArray)
    }
    
    func test_givenRestaurantServiceReturnsFailure_whenSearchingRestaurantsNearbyForLocation_thenMapError() {
        // Given
        let restaurantError = RestaruantServiceError.networkError
        mockRestaurantService.searchRestaurantsNearbyHandler = { _ in
            Fail(error: restaurantError).eraseToAnyPublisher()
        }
        useCase = makeUseCase()
        
        var correctErrorReThrown = false
        
        // When
        useCase.searchRestaurantsNearby(location: Location(latitude: 0, longitude: 0))
            .sink { completion in
                switch completion {
                case .failure(let error):
                    correctErrorReThrown = (error as? RestaruantServiceError) == restaurantError
                case .finished:
                    print("Finished")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)

        // Then
        XCTAssertTrue(correctErrorReThrown)
    }
    
    private func makeUseCase() -> NearbyRestaurantsUseCase {
        LiveNearbyRestaurantsUseCase(restaurantsService: mockRestaurantService)
    }
    
    private func createDummySections() -> [Section] {
        [
            Section(items: [
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description")),
                Restaurant(image: RestaurantImage(url: ""), venue: Venue(id: "id", name: "name", shortDescription: "description"))
            ])
        ]
    }
}
