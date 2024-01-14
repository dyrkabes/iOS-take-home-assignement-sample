//
//  WeatherRequesting.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 13.01.24.
//

import Foundation

enum NetworkError: Error {
    case network, noInternet, timedOut
}

protocol WeatherRequesting {
    func requestWeatherData() async -> Result<WeatherData, NetworkError>
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

    func requestWeatherData() async -> Result<WeatherData, NetworkError> {
        do {
            let urlString = "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true"
            let request = URLRequest(url: .init(string: urlString)!)
            let (data, _) = try await httpRequester.data(for: request)
            let weatherDataDTO = try decoder.decode(WeatherDataDTO.self, from: data)
            return .success(WeatherConverter.weatherData(from: weatherDataDTO))
        } catch {
            print(error)
            return .failure(WeatherRequester.convert(error: error))
        }
    }

    private static func convert(error: Error) -> NetworkError {
        guard let urlError = error as? URLError else {
            return .network
        }
        switch urlError.code {
        case .notConnectedToInternet:
            return .noInternet
        case .timedOut:
            return .timedOut
        default:
            return .network
        }
    }
}
