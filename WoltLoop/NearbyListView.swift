//
//  NearbyListView.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import SwiftUI

struct NearbyListView: View {
    @StateObject var viewModel = NearbyListViewModel()
    
    var body: some View {
        List(viewModel.restaurants) { restaurant in
            Text(restaurant.name)
        }
        .listStyle(PlainListStyle())
    }
}

struct NearbyListView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyListView()
    }
}
