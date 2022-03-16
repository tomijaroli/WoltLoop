//
//  AnalyticsEventTracker.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import Foundation

protocol AnalyticsEventTracker {
    func send(event: AnalyticsEvent)
}

final class SomeRemoteAnalyticsEventTracker: AnalyticsEventTracker {
    func send(event: AnalyticsEvent) {
        // This could send analytics events to segment, amplitude, DataDog, etc...
    }
}
