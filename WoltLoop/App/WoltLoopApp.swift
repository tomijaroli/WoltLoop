//
//  WoltLoopApp.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 14..
//

import SwiftUI
import Swinject

@main
struct WoltLoopApp: App {
    private let assembler: Assembler
    
    init() {
        self.assembler = Assembler([NearbyRestaurantAssembly()])
    }
    
    var body: some Scene {
        WindowGroup {
            NearbyListView()
                .environmentObject(assembler.resolver.resolve(NearbyRestaurantsViewModel.self)!)
        }
    }
}
