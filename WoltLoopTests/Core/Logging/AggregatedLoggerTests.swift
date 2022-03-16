//
//  AggregatedLoggerTests.swift
//  WoltLoopTests
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import XCTest
@testable import WoltLoop

class AggregatedLoggerTests: XCTestCase {
    private var aggregatedLogger: WoltLoopLogger!
    private var mockLogger1: WoltLoopLoggerMock!
    private var mockLogger2: WoltLoopLoggerMock!
    
    override func setUp() {
        mockLogger1 = WoltLoopLoggerMock()
        mockLogger2 = WoltLoopLoggerMock()
    }
    
    func test_givenLoggers_whenLogDebugCalledOnAggregated_thenLoggersCallDebugToo() {
        // Given
        aggregatedLogger = makeAggregatedLogger()
        
        // When
        aggregatedLogger.logDebug(message: "DEBUG MESSAGE")
        
        // Then
        XCTAssertEqual(mockLogger1.logDebugCallCount, 1)
        XCTAssertEqual(mockLogger2.logDebugCallCount, 1)
    }
    
    func test_givenLoggers_whenLogErrorCalledOnAggregated_thenLoggersCallErrorToo() {
        // Given
        aggregatedLogger = makeAggregatedLogger()
        
        // When
        aggregatedLogger.logError(message: "ERROR MESSAGE", error: nil)
        
        // Then
        XCTAssertEqual(mockLogger1.logErrorCallCount, 1)
        XCTAssertEqual(mockLogger2.logErrorCallCount, 1)
    }
    
    private func makeAggregatedLogger() -> WoltLoopLogger {
        AggregatedLogger(with: [mockLogger1, mockLogger2])
    }
}
