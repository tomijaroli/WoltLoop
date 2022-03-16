//
//  Timer.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import Foundation

typealias TimerFactory = (TimeInterval, @escaping((TimerProtocol) -> Void)) -> TimerProtocol

/// @mockable
protocol TimerProtocol {
    var isValid: Bool { get }
    static func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer
    func invalidate()
}

extension Timer: TimerProtocol {}
