//
//  RestaurantViewModelTests.swift
//  WoltLoopTests
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation
import XCTest
@testable import WoltLoop

class RestaurantViewModelTests: XCTestCase {
    private var viewModel: RestaurantViewModel!
    
    func testGivenValidImageUrlString_whenInitializingViewModel_thenUrlHasValue() {
        // Given
        let validImageUrlString =
            "https://prod-wolt-venue-images-cdn.wolt.com/5e6b49d0495c5b922ce600a7/d810354e-2823-11ec-9676-faa36b7ea200_img_5244.jpeg"
        
        // When
        viewModel = RestaurantViewModel(
            id: "some id",
            name: "some name",
            shortDescription: "some description",
            imageUrl: validImageUrlString,
            isFavourite: false
        )
        
        // Then
        XCTAssertNotNil(viewModel.imageUrl)
    }
    
    func testGivenInValidImageUrlString_whenInitializingViewModel_thenUrlHasNoValue() {
        // Given
        let invalidImageUrlString = "invalid img url"
        
        // When
        viewModel = RestaurantViewModel(
            id: "some id",
            name: "some name",
            shortDescription: "some description",
            imageUrl: invalidImageUrlString,
            isFavourite: false
        )
        
        // Then
        XCTAssertNil(viewModel.imageUrl)
    }
    
    func testGivenEmptyImageUrlString_whenInitializingViewModel_thenUrlHasNoValue() {
        // Given
        let emptyImageUrlString = String()
        
        // When
        viewModel = RestaurantViewModel(
            id: "some id",
            name: "some name",
            shortDescription: "some description",
            imageUrl: emptyImageUrlString,
            isFavourite: false
        )
        
        // Then
        XCTAssertNil(viewModel.imageUrl)
    }
}
