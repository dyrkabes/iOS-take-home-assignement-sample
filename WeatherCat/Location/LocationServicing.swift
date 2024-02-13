//
//  LocationServicing.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 04.02.24.
//

import Combine

protocol LocationServicing {
    var currentLocation: AnyPublisher<LocationState, Never> { get }

    func start()
    func stop()
}
