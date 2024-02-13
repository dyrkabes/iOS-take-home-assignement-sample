//
//  WeatherRequester.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 13.01.24.
//

import Foundation

enum NetworkError: Error {
    case network, noInternet, timedOut
}

protocol WeatherRequesting {
    func requestWeatherData(latitude: Double, longitude: Double) async -> Result<WeatherData, NetworkError>
}

final class WeatherRequester: WeatherRequesting {
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    private let httpRequester: HttpRequesting

    init(httpRequester: HttpRequesting = URLSession.shared) {
        self.httpRequester = httpRequester
    }

    func requestWeatherData(latitude: Double, longitude: Double) async -> Result<WeatherData, NetworkError> {
        do {
            let request = URLRequest(url: APIs.Weather.currentWeather(latitude: latitude, longitude: longitude).makeURL())
            let (data, _) = try await httpRequester.data(for: request)
            let weatherDataDTO = try decoder.decode(WeatherDataDTO.self, from: data)
            return .success(WeatherConverter.weatherData(from: weatherDataDTO))
        } catch {
            return .failure(ErrorConverter.convert(error: error))
        }
    }
}
