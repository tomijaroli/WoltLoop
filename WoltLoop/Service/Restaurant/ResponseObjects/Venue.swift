//
//  Venue.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation

struct Venue: Codable {
    let address: String
    let currency: String
    let deliveryPrice: String
    let estimate: Int
    let id: String
    let location: [Float]
    let name: String
    let shortDescription: String?
}
