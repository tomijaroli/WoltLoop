//
//  NearbyRestaurantsAnalyticsTracker.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import Foundation

private enum NearbyRestaurantsAnalyticsEvents: String {
    case restaurantsLoaded = "Restaurants loaded"
    case toggleFavourite = "Favourite toggled"
}

/// @mockable
protocol NearbyRestaurantsAnalyticsTracker {
    func logRestaurantsLoaded()
    func toggleFavourite(for restaurantId: String)
}

final class LiveNearbyRestaurantsAnalyticsTracker {
    private let analyticsEventTracker: AnalyticsEventTracker
    
    init(analyticsEventTracker: AnalyticsEventTracker) {
        self.analyticsEventTracker = analyticsEventTracker
    }
}

extension LiveNearbyRestaurantsAnalyticsTracker: NearbyRestaurantsAnalyticsTracker {
    func logRestaurantsLoaded() {
        trackEvent(event: .restaurantsLoaded)
    }
    
    func toggleFavourite(for restaurantId: String) {
        trackEvent(event: .toggleFavourite, parameters: ["restaurantId": restaurantId])
    }
    
    private func trackEvent(event: NearbyRestaurantsAnalyticsEvents, parameters: [String: String]? = nil) {
        analyticsEventTracker.send(event: AnalyticsEvent(eventName: event.rawValue, parameters: parameters))
    }
}
