//
//  LocationState.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 27.01.24.
//

enum LocationState {
    case loading
    case loaded(coordinate: Coordinate)
    case error
}
