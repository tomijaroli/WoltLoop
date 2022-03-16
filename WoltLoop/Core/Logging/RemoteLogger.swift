//
//  RemoteLogger.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import Foundation

final class RemoteLogger {}

extension RemoteLogger: WoltLoopLogger {
    func logDebug(message: String) {
        // This could be a remote logger for debug information, like Firebase or AppSpector.
    }
    
    func logError(message: String, error: Error?) {
        // This could be a remote logger for error information, like Firebase or AppSpector.
    }
}
