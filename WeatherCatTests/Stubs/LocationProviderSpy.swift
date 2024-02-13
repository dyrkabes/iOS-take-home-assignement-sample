//
//  LocationProviderSpy.swift
//  WeatherCatTests
//
//  Created by Pavel Stepanov on 13.02.24.
//

import CoreLocation

@testable import WeatherCat

final class LocationProviderSpy: LocationProviding {

    var stubbedDelegate: CLLocationManagerDelegate!

    var delegate: CLLocationManagerDelegate? {
        set {
            stubbedDelegate = newValue
        }
        get {
            return stubbedDelegate
        }
    }

    var invokedStartUpdatingLocationCount = 0

    func startUpdatingLocation() {
        invokedStartUpdatingLocationCount += 1
    }

    var invokedStopUpdatingLocationCount = 0

    func stopUpdatingLocation() {
        invokedStopUpdatingLocationCount += 1
    }
}
