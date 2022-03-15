//
//  LocationProvider.swift
//  WoltLoop
//
//  Created by Tom Jaroli on 2022. 03. 15..
//

import Foundation
import Combine

protocol LocationProvider {
    var locationPublisher: AnyPublisher<Location, Never> { get }
}

final class LoopedLocationProvider {
    private let currentLocationSubject: CurrentValueSubject<Location, Never>
    
    private var timer: Timer?
    private var currentCoordinateIndex: Int
    
    init() {
        self.currentCoordinateIndex = 0
        self.currentLocationSubject = CurrentValueSubject<Location, Never>(coordinates[self.currentCoordinateIndex])
        startRotating()
    }
    
    func startRotating() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            self.rotateCoordinates()
        }
    }
    
    @objc
    private func rotateCoordinates() {
        if currentCoordinateIndex + 1 == coordinates.count {
            currentCoordinateIndex = 0
        } else {
            currentCoordinateIndex += 1
        }
        
        currentLocationSubject.send(coordinates[currentCoordinateIndex])
    }
}

extension LoopedLocationProvider: LocationProvider {
    var locationPublisher: AnyPublisher<Location, Never> {
        currentLocationSubject.eraseToAnyPublisher()
    }
}

fileprivate let coordinates = [
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
