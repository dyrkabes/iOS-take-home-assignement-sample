//
//  HttpRequester.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 13.01.24.
//

import Foundation

protocol HttpRequesting {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: HttpRequesting {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}
