//
//  Restaurant.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation

struct Restaurant: Codable {
    let image: RestaurantImage
    let title: String
    let venue: Venue
}
