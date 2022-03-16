//
//  CoreAssembly.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 16..
//

import Foundation
import Swinject
import SwinjectAutoregistration

final class CoreAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkProvider<RestaurantsEndpoint>.self) { resolver in
            NetworkProvider(decoder: .init(), session: URLSession.shared, logger: resolver.resolve(WoltLoopLogger.self)!)
        }
        
        container.autoregister(
            NetworkProvider<RestaurantsEndpoint>.self,
            argument: JSONDecoder.self,
            initializer: NetworkProvider.init
        )
        
        container.register(LocationProvider.self) { _ in
            LoopedLocationProvider(timerFactory: {
                return Timer.scheduledTimer(withTimeInterval: $0, repeats: true, block: $1)
            })
        }
        
        container.register(WoltLoopLogger.self) { _ in
            AggregatedLogger(with: [OSLogger(), RemoteLogger()])
        }
    }
}