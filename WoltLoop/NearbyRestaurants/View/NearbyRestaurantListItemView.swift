//
//  NearbyRestaurantListItemView.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import SwiftUI

struct NearbyRestaurantListItemView: View {
    private enum Constants {
        static let imageSize = 64.0
        static let imageCornerRadius = 12.0
        static let textSpacing = 4.0
        static let favouritesIconSize = 24.0
    }
    
    @ObservedObject var restaurantViewModel: RestaurantViewModel
    var markAsFavourite: (RestaurantViewModel) -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: restaurantViewModel.imageUrl) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(Constants.imageCornerRadius)
            
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: Constants.textSpacing) {
                        Text(restaurantViewModel.name)
                            .font(.headline)
                            .lineLimit(1)
                        restaurantViewModel.shortDescription.map { shortDescription in
                            Text(shortDescription)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                    }
                 
                    Spacer()
                    
                    Button {
                        markAsFavourite(restaurantViewModel)
                    } label: {
                        Image(restaurantViewModel.isFavourite ?
                              "favourite_filled" :
                              "favourite_outlined")
                            .resizable()
                            .frame(width: Constants.favouritesIconSize, height: Constants.favouritesIconSize)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.leading)
            }
            .padding(0)
        }
    }
}

struct NearbyRestaurantListItemView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyRestaurantListItemView(restaurantViewModel: mockRestaurants[0], markAsFavourite: { _ in })
            .previewLayout(.fixed(width: 360, height: 80))
            .padding()
    }
}
