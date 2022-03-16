//
//  RestaurantEndpointTests.swift
//  WoltLoopTests
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import XCTest
@testable import WoltLoop

class RestaurantEndpointTests: XCTestCase {
    private var endpoint: RestaurantsEndpoint!
    
    func test_whenEndpointIsSearchNearby_thenPropertiesMatch() {
        // Given
        let latitude = 123541.12235523
        let longitude = 342511.34235355
        let expectedURL = URL(string: "https://restaurant-api.wolt.com")!
        let expectedApiVersion = "v1"
        let expectedPath = "pages/restaurants"
        let expectedMethod = HTTPMethod.get
        let expectedParameters = ["lat": String(format: "%.05f", latitude), "lon": String(format: "%.05f", longitude)]
        let expectedHeaders = ["Content-Type": "application/json"]
        
        // When
        endpoint = .nearby(latitude: latitude, longitude: longitude)
        
        // Then
        XCTAssertEqual(endpoint.baseURL, expectedURL)
        XCTAssertEqual(endpoint.apiVersion, expectedApiVersion)
        XCTAssertEqual(endpoint.path, expectedPath)
        XCTAssertEqual(endpoint.method, expectedMethod)
        XCTAssertEqual(endpoint.parameters, expectedParameters)
        XCTAssertEqual(endpoint.headers, expectedHeaders)
    }
}
