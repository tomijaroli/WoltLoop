//
//  ErrorLogger.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//


// TODO: refactor
import Foundation
import os.log

/// @mockable
protocol ErrorLogger {
    func log(_ error: Error)
}

public class OSErrorLogger {}

extension OSErrorLogger: ErrorLogger {
    func log(_ error: Error) {
        Logger.error.error("\(error.localizedDescription)")
    }
}

extension Logger {
    private static var subsytem = Bundle.main.bundleIdentifier!
    
    static let error = Logger(subsystem: subsytem, category: "default")
}
