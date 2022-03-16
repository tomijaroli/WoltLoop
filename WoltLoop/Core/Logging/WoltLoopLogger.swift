//
//  Logger.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import Foundation

/// @mockable
protocol WoltLoopLogger {
    func logDebug(message: String)
    func logError(message: String, error: Error?)
}
