//
//  WeatherDataDTO.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 13.01.24.
//

import Foundation

struct WeatherDataDTO: Decodable {
    let currentWeather: CurrentWeather
}

extension WeatherDataDTO {
    struct CurrentWeather: Decodable {
        let temperature: Double
        let weatherCode: Int

        enum CodingKeys: String, CodingKey {
            case temperature
            case weatherCode = "weathercode"
        }
    }
}
