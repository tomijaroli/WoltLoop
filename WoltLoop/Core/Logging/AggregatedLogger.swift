//
//  AggregatedLogger.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import Foundation

final class AggregatedLogger {
    private let loggers: [WoltLoopLogger]
    
    init(with loggers: [WoltLoopLogger]) {
        self.loggers = loggers
    }
}

extension AggregatedLogger: WoltLoopLogger {
    func logDebug(message: String) {
        loggers.forEach { $0.logDebug(message: message) }
    }
    
    func logError(message: String, error: Error?) {
        loggers.forEach { $0.logError(message: message, error: error) }
    }
}
