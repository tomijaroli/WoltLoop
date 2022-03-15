//
//  PreviewBuilder.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation
import Swinject
import SwiftUI

final class PreviewBuilder {
    static let shared = PreviewBuilder()
    
    private var assembler: Assembler!
    
    func setup(with assembler: Assembler) {
        self.assembler = assembler
    }
    
    func buildNearbyRestaurantsPreview() -> AnyView {
        let viewModel = assembler.resolver.resolve(NearbyRestaurantsViewModel.self)!
        
        return AnyView(NearbyRestaurantsView(viewModel: viewModel))
    }
}
