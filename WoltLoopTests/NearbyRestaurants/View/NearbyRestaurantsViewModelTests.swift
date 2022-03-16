//
//  NearbyRestaurantsViewModelTests.swift
//  WoltLoopTests
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import XCTest
import Combine
@testable import WoltLoop

class NearbyRestaurantsViewModelTests: XCTestCase {
    private var viewModel: NearbyRestaurantsViewModel!
    private var mockNearbyRestaurantsUseCase: NearbyRestaurantsUseCaseMock!
    private var mockLocationProvider: LocationProviderMock!
    private var mockFavouriteRestaurantsUseCase: FavouriteRestaurantsUseCaseMock!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        mockNearbyRestaurantsUseCase = NearbyRestaurantsUseCaseMock()
        mockLocationProvider = LocationProviderMock()
        mockFavouriteRestaurantsUseCase = FavouriteRestaurantsUseCaseMock()
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables = Set<AnyCancellable>()
    }
    
    func test_whenLocationProviderEmitsLocation_thenNearbyRestaurantsRequestedFromUseCase() {
        // Given
        mockNearbyRestaurantsUseCase.searchRestaurantsNearbyHandler = { _ in
            Empty().eraseToAnyPublisher()
        }
        viewModel = makeViewModel()
        
        // When
        mockLocationProvider.locationPublisherSubject.send(Location(latitude: 0, longitude: 0))
        
        // Then
        XCTAssertEqual(mockNearbyRestaurantsUseCase.searchRestaurantsNearbyCallCount, 1)
    }
    
    func test_givenNearbyRestaurantsUseCaseReturnsRestaurants_whenLocationReceived_thenRestaurantsArePublished() {
        // Given
        let restaurants = [makeRestaurant(), makeRestaurant()]
        let expectation = XCTestExpectation(description: "")
        givenNearbyRestuarntsUseCaseReturnsRestaurants(restaurants)
        
        viewModel = makeViewModel()
        viewModel.$restaurants.sink { restaurants in
            if !restaurants.isEmpty {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        // When
        mockLocationProvider.locationPublisherSubject.send(Location(latitude: 0, longitude: 0))
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.restaurants, restaurants)
    }
    
    func test_givenNearbyRestaurantsUseCaseReturnsRestaurants_whenLocationReceived_thenFavouritesAreDecorated() {
        // Given
        let restaurants = [makeRestaurant(), makeRestaurant()]
        let expectation = XCTestExpectation(description: "")
        givenNearbyRestuarntsUseCaseReturnsRestaurants(restaurants)
        
        viewModel = makeViewModel()
        viewModel.$restaurants.sink { restaurants in
            if !restaurants.isEmpty {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        // When
        mockLocationProvider.locationPublisherSubject.send(Location(latitude: 0, longitude: 0))
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(mockFavouriteRestaurantsUseCase.decorateFavouritesCallCount, 1)
    }
    
    func test_givenNearbyRestaurantsUseCaseReturnsFailure_whenLocationReceived_thenErrorsAreHandled() {
        // Given
        let expectation = XCTestExpectation(description: "")
        givenNearbyRestuarntsUseCaseReturnsFailure()
        
        viewModel = makeViewModel()
        viewModel.$errorMessage.sink { error in
            if error != nil {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        // When
        mockLocationProvider.locationPublisherSubject.send(Location(latitude: 0, longitude: 0))
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Oops! Something went wrong!")
    }
    
    func test_givenSelectedRestaurant_whenPressMarkAsSelected_thenFavouriteUseCaseWillBeCalled() {
        // Given
        let selectedRestaurant = makeRestaurant()
        viewModel = makeViewModel()
        
        // When
        viewModel.markRestaurantFavourite(restaurant: selectedRestaurant)
        
        // Then
        XCTAssertEqual(mockFavouriteRestaurantsUseCase.toggleFavouriteCallCount, 1)
    }
    
    private func makeViewModel() -> NearbyRestaurantsViewModel {
        .init(
            nearbyRestaurantsUseCase: mockNearbyRestaurantsUseCase,
            locationProvider: mockLocationProvider,
            favouriteRestaurantsUseCase: mockFavouriteRestaurantsUseCase
        )
    }
    
    private func makeRestaurant() -> RestaurantViewModel {
        .init(id: "id", name: "name", shortDescription: "description", imageUrl: nil, isFavourite: false)
    }
    
    private func givenNearbyRestuarntsUseCaseReturnsRestaurants(_ restaurants: [RestaurantViewModel]) {
        mockNearbyRestaurantsUseCase.searchRestaurantsNearbyHandler = { _ in
            return Just(restaurants).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    private func givenNearbyRestuarntsUseCaseReturnsFailure() {
        mockNearbyRestaurantsUseCase.searchRestaurantsNearbyHandler = { _ in
            return Fail(error: RestaruantServiceError.networkError).eraseToAnyPublisher()
        }
    }
}
