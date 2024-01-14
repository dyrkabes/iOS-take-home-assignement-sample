//
//  WeatherDataConverter.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 13.01.24.
//

enum WeatherConverter {
    static func weatherData(from dto: WeatherDataDTO) -> WeatherData {
        .init(temperature: dto.currentWeather.temperature, type: weatherType(from: dto.currentWeather.weatherCode))
    }

    private static func weatherType(from weatherCode: Int) -> WeatherData.WeatherType {
        switch weatherCode {
        case 0:
            return .clear
        case 1, 2, 3:
            return .partlyCloudy
        case 45, 48:
            return .fog
        case 51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82:
            return .rain
        case 71, 73, 75, 77, 85, 86:
            return .snow
        case 95, 96, 99:
            return .thunderstorm
        default:
            return .unknown
        }
    }
}
