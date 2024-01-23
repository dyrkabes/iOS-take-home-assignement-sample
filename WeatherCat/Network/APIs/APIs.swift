//
//  APIs.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 15.01.24.
//

import Foundation

protocol API {
    var urlString: String { get }
    var queryParameters: [String: CustomStringConvertible] { get }
}

extension API {
    func makeURL() -> URL {
        guard var components = URLComponents(string: urlString) else {
            fatalError("Could not construct URLComponents for \(urlString)")
        }
        components.queryItems = queryParameters.map { .init(name: $0.key, value: $0.value.description) }
        return components.url!
    }
}

enum APIs {
    enum Weather: API {
        case currentWeather(latitude: Double, longitude: Double)

        var urlString: String {
            switch self {
            case .currentWeather:
                return "https://api.open-meteo.com/v1/forecast"
            }
        }

        var queryParameters: [String: CustomStringConvertible] {
            switch self {
            case let .currentWeather(latitude, longitude):
                return ["latitude": latitude, "longitude": longitude, "current_weather": true]
            }
        }
    }
}
