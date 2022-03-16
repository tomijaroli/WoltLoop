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
    private var timer: Timer!
    private var mockLogger: WoltLoopLoggerMock!
    
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        TimerProtocolMock.scheduledTimerHandler = {
            self.timer = Timer.scheduledTimer(withTimeInterval: $0, repeats: false, block: $2)
            return self.timer
        }
        mockLogger = WoltLoopLoggerMock()
    }
    
    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables = Set<AnyCancellable>()
    }
    
    func test_whenLocationProviderIsInitialized_thenStartsRotatingLocationsAndEmitsNewOne() {
        // Given
        let expectation = XCTestExpectation()
        mockTimerFactory = makeMockTimerFactory(expectation: expectation)
        locationProvider = makeLocationProvider()
        var newLocationReceived = false
        
        // When
        locationProvider.locationPublisher.sink { _ in } receiveValue: { _ in
            newLocationReceived = true
        }
        .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(newLocationReceived)
        XCTAssertEqual(mockLogger.logDebugCallCount, 2)
    }
    
    func test_givenRunningTimer_whenPaused_thenTimerIsInvalid() {
        // Given
        locationProvider = makeLocationProvider()
        
        // When
        locationProvider.pause()
        
        // Then
        XCTAssertFalse(timer.isValid)
        XCTAssertEqual(mockLogger.logDebugCallCount, 1)
    }
    
    func test_givenInvalidTimer_whenResumed_thenStartsRotating() {
        // Given
        locationProvider = makeLocationProvider()
        locationProvider.pause()
        
        // When
        locationProvider.resume()
        
        // Then
        XCTAssertTrue(timer.isValid)
        XCTAssertEqual(mockLogger.logDebugCallCount, 2)
    }
    
    private func makeLocationProvider() -> LocationProvider {
        LoopedLocationProvider(timerFactory: mockTimerFactory, logger: mockLogger)
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
