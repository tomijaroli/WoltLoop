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
            ErrorLogger.self,
            initializer: OSErrorLogger.init
        )
        
        container.register(NetworkProvider<RestaurantsEndpoint>.self) { resolver in
            NetworkProvider(decoder: .init(), session: URLSession.shared, errorLogger: resolver.resolve(ErrorLogger.self)!)
        }
        
        container.autoregister(
            NetworkProvider<RestaurantsEndpoint>.self,
            argument: JSONDecoder.self,
            initializer: NetworkProvider.init
        )
        
        container.autoregister(
            RestaurantService.self,
            initializer: RestaurantServiceClient.init
        )
        
        container.autoregister(
            NearbyRestaurantsUseCase.self,
            initializer: LiveNearbyRestaurantsUseCase.init
        )
        
        container.autoregister(
            LocationProvider.self,
            initializer: LoopedLocationProvider.init
        )
        
        container.autoregister(
            FavouriteRestaurantsUseCase.self,
            initializer: LiveFavouriteRestaurantsUseCase.init
        )
        
        container.autoregister(
            NearbyRestaurantsViewModel.self,
            initializer: NearbyRestaurantsViewModel.init
        )
    }
}
