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
        
        container.register(LocationProvider.self) { resolver in
            LoopedLocationProvider(
                timerFactory: {
                    return Timer.scheduledTimer(withTimeInterval: $0, repeats: true, block: $1)
                },
                logger: resolver.resolve(WoltLoopLogger.self)!
            )
        }
        
        container.register(WoltLoopLogger.self) { _ in
            AggregatedLogger(with: [OSLogger(), RemoteLogger()])
        }
        
        container.autoregister(
            AnalyticsEventTracker.self,
            initializer: SomeRemoteAnalyticsEventTracker.init
        )
    }
}
