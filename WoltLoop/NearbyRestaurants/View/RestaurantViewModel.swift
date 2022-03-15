//
//  RestaurantViewModel.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation
import Combine

class RestaurantViewModel: ObservableObject, Identifiable {
    let id: String
    let name: String
    let shortDescription: String?
    var imageUrl: URL?
    
    @Published var isFavourite: Bool
    
    init(id: String, name: String, shortDescription: String?, imageUrl: String?, isFavourite: Bool) {
        self.id = id
        self.name = name
        self.shortDescription = shortDescription
        self.isFavourite = isFavourite
        
        if let imageUrlString = imageUrl, !imageUrlString.isEmpty {
            self.imageUrl = URL(string: imageUrlString)
        }
    }
}

extension RestaurantViewModel: Equatable {
    static func == (lhs: RestaurantViewModel, rhs: RestaurantViewModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}
