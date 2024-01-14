//
//  WeatherData.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 13.01.24.
//

import Foundation

struct WeatherData {
    let temperature: Double
    let type: WeatherType
}

extension WeatherData {
    enum WeatherType {
        case clear, partlyCloudy, fog, rain, snow, thunderstorm, unknown
    }
}
