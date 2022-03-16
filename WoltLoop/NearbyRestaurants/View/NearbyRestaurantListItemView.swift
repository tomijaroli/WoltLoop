//
//  NearbyRestaurantListItemView.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import SwiftUI

struct NearbyRestaurantListItemView: View {
    @ObservedObject var restaurantViewModel: RestaurantViewModel
    var markAsFavourite: (RestaurantViewModel) -> Void
    
    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: restaurantViewModel.imageUrl) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 64, height: 64)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(12)
            VStack {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
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
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.leading, 16)
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
