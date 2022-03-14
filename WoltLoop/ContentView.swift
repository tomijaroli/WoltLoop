//
//  ContentView.swift
//  Wolt Loop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NearbyListView()
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
