//
//  LocationProviding.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 13.02.24.
//

import CoreLocation

protocol LocationProviding: AnyObject {
    var delegate: CLLocationManagerDelegate? { get set }
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

extension CLLocationManager: LocationProviding {}
