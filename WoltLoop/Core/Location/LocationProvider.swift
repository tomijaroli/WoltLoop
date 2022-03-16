//
//  LocationProvider.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation
import Combine

/// @mockable
protocol LocationProvider {
    var locationPublisher: AnyPublisher<Location, Never> { get }
    func pause()
    func resume()
}

final class LoopedLocationProvider {
    private let currentLocationSubject: CurrentValueSubject<Location, Never>

    private var currentCoordinateIndex: Int
    private var rotationTimer: TimerProtocol?
    
    private let timerFactory: TimerFactory
    private let logger: WoltLoopLogger
    
    init(
        timerFactory: @escaping TimerFactory,
        logger: WoltLoopLogger
    ) {
        self.timerFactory = timerFactory
        self.logger = logger
        
        self.currentCoordinateIndex = 0
        self.currentLocationSubject = CurrentValueSubject<Location, Never>(coordinates[self.currentCoordinateIndex])
        startRotating()
    }
    
    private func startRotating() {
        rotationTimer = timerFactory(10.0) { [weak self] _ in
            guard let self = self else { return }
            self.rotateCoordinates()
        }
    }
    
    @objc
    private func rotateCoordinates() {
        logger.logDebug(message: "Rotating coordinates...")
        if currentCoordinateIndex + 1 == coordinates.count {
            currentCoordinateIndex = 0
        } else {
            currentCoordinateIndex += 1
        }
        logger.logDebug(message: "New coordinate index is \(currentCoordinateIndex)")
        currentLocationSubject.send(coordinates[currentCoordinateIndex])
    }
}

extension LoopedLocationProvider: LocationProvider {
    var locationPublisher: AnyPublisher<Location, Never> {
        currentLocationSubject.eraseToAnyPublisher()
    }
    
    func pause() {
        logger.logDebug(message: "Location provider paused.")
        rotationTimer?.invalidate()
    }
    
    func resume() {
        logger.logDebug(message: "Location provider resumed.")
        startRotating()
    }
}

private let coordinates = [
    Location(latitude: 60.170187, longitude: 24.930599),
    Location(latitude: 60.169418, longitude: 24.931618),
    Location(latitude: 60.169818, longitude: 24.932906),
    Location(latitude: 60.170005, longitude: 24.935105),
    Location(latitude: 60.169108, longitude: 24.936210),
    Location(latitude: 60.168355, longitude: 24.934869),
    Location(latitude: 60.167560, longitude: 24.932562),
    Location(latitude: 60.168254, longitude: 24.931532),
    Location(latitude: 60.169012, longitude: 24.930341),
    Location(latitude: 60.170085, longitude: 24.929569)
]
