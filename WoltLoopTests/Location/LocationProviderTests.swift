//
//  LocationProviderTests.swift
//  WoltLoopTests
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import XCTest
import Combine
@testable import WoltLoop

class LocationProviderTests: XCTestCase {
    private var locationProvider: LocationProvider!
    private var mockTimerFactory: TimerFactory = { _, block in
        TimerProtocolMock.scheduledTimer(withTimeInterval: 0.0, repeats: true, block: block)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        TimerProtocolMock.scheduledTimerHandler = {
            Timer.scheduledTimer(withTimeInterval: $0, repeats: false, block: $2)
        }
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables = Set<AnyCancellable>()
    }
    
    func test_whenLocationProviderIsInitialized_thenStartsRotatingLocationsAndEmitsNewOne() {
        let expectation = XCTestExpectation()
        mockTimerFactory = makeMockTimerFactory(expectation: expectation)
        locationProvider = makeLocationProvider()
        var newLocationReceived = false
        
        locationProvider.locationPublisher.sink { _ in } receiveValue: { location in
            newLocationReceived = true
        }
        .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(newLocationReceived)
    }
    
    private func makeLocationProvider() -> LocationProvider {
        LoopedLocationProvider(timerFactory: mockTimerFactory)
    }
    
    private func makeMockTimerFactory(expectation: XCTestExpectation) -> TimerFactory {
        { _, block in
            TimerProtocolMock.scheduledTimer(withTimeInterval: 0.0, repeats: true, block: {
                block($0)
                expectation.fulfill()
            })
        }
    }
}
