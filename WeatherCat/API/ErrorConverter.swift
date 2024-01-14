//
//  ErrorConverter.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 14.01.24.
//

import Foundation

enum ErrorConverter {
    static func convert(error: Error) -> NetworkError {
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
