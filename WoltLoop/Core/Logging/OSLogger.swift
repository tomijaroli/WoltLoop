//
//  OSLogger.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import Foundation
import os.log

final class OSLogger {
    private enum LogConstants {
        static let subsystem = "com.tomjaroli.woltloop"
        static let category = "app"
    }
    
    private let logger: Logger
    
    init() {
        logger = Logger(subsystem: LogConstants.subsystem, category: LogConstants.category)
    }
}

extension OSLogger: WoltLoopLogger {
    func logDebug(message: String) {
        logger.debug("\(message, privacy: .public)")
    }
    
    func logError(message: String, error: Error?) {
        var errorMessage = message

        if let error = error {
            errorMessage.append("\n\(error.localizedDescription)")
        }
        
        logger.error("\(errorMessage, privacy: .public)")
    }
}
