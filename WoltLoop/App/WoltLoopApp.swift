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
        self.assembler = Assembler([CoreAssembly(), NearbyRestaurantAssembly()])
        PreviewBuilder.shared.setup(with: assembler)
    }
    
    var body: some Scene {
        WindowGroup {
            NearbyRestaurantsView(viewModel: assembler.resolver.resolve(NearbyRestaurantsViewModel.self)!)
        }
    }
}
