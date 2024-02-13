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
    var currentLocation: AnyPublisher<LocationState, Never> {
        _currentLocation.eraseToAnyPublisher()
    }
    private let _currentLocation = CurrentValueSubject<LocationState, Never>(.loading)

    private var hasStarted = false

    private let locationProvider: LocationProviding

    init(locationProvider: LocationProviding = CLLocationManager()) {
        self.locationProvider = locationProvider
    }

    func start() {
        guard !hasStarted else {
            return
        }
        hasStarted = true
        locationProvider.delegate = self
        locationProvider.startUpdatingLocation()
    }

    func stop() {
        hasStarted = false
        locationProvider.stopUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        let coordinate = Coordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        _currentLocation.send(.loaded(coordinate: coordinate))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _currentLocation.send(.error)
    }
}
