//
//  NearbyRestaurantsAssembly.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class NearbyRestaurantAssembly: Assembly {
    func assemble(container: Container) {
        container.autoregister(
            RestaurantService.self,
            initializer: RestaurantServiceClient.init
        )
        
        container.autoregister(
            NearbyRestaurantsUseCase.self,
            initializer: LiveNearbyRestaurantsUseCase.init
        )
        
        container.autoregister(
            FavouriteRestaurantsUseCase.self,
            initializer: LiveFavouriteRestaurantsUseCase.init
        )
        
        container.autoregister(
            NearbyRestaurantsAnalyticsTracker.self,
            initializer: LiveNearbyRestaurantsAnalyticsTracker.init
        )
        
        container.autoregister(
            NearbyRestaurantsViewModel.self,
            initializer: NearbyRestaurantsViewModel.init
        )
    }
}
