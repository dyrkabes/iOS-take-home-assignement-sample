//
//  SpyHttpRequester.swift
//  WeatherCatTests
//
//  Created by Pavel Stepanov on 13.01.24.
//

import Foundation
@testable import WeatherCat

final class SpyHttpRequester: HttpRequesting {
    private(set) var invokedDataCounter = 0
    var stubbedResult: (Data, URLResponse)!

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        invokedDataCounter += 1
        return stubbedResult
    }
}