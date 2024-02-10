//
//  LocationService.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 04.02.24.
//

import Combine
import CoreLocation
import Foundation

final class LocationService: NSObject, LocationServicing {
    var currentLocation: AnyPublisher<DataState<Coordinate>, Never> {
        _currentLocation.eraseToAnyPublisher()
    }
    private let _currentLocation = CurrentValueSubject<DataState<Coordinate>, Never>(.loading)

    private var hasStarted = false

    private let locationManager = CLLocationManager()

    func start() {
        guard !hasStarted else {
            return
        }
        hasStarted = true
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func stop() {
        hasStarted = false
        locationManager.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let coordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        _currentLocation.send(.loaded(data: coordinate))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _currentLocation.send(.error)
    }
}
