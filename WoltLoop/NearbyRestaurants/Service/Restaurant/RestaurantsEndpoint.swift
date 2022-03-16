//
//  NearbyEndpoint.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import Foundation

enum RestaurantsEndpoint {
    case nearby(latitude: Double, longitude: Double)
}

extension RestaurantsEndpoint: Endpoint {
    var baseURL: URL {
        URL(string: "https://restaurant-api.wolt.com")!
    }
    
    var apiVersion: String {
        "v1"
    }
    
    var path: String {
        switch self {
        case .nearby:
            return "pages/restaurants"
        }
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var parameters: [String: String]? {
        switch self {
        case .nearby(let latitude, let longitude):
            let floatFormat = "%.05f"
            return ["lat": String(format: floatFormat, latitude), "lon": String(format: floatFormat, longitude)]
        }
    }
    
    var body: Encodable? {
        nil
    }
    
    var headers: [String: String]? {
        let headers = ["Content-Type": "application/json"]
        return headers
    }
}
