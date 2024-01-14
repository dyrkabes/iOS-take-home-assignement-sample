//
//  NetworkRequesterTest.swift
//  WeatherCatTests
//
//  Created by Pavel Stepanov on 13.01.24.
//

import XCTest

@testable import WeatherCat

final class NetworkRequesterTest: XCTestCase {
    // MARK: - Dependencies -

    private var sut: WeatherRequester!
    private var httpRequester: SpyHttpRequester!

    // MARK: - Setup -

    override func setUp() {
        self.httpRequester = .init()
        sut = .init(httpRequester: httpRequester)
    }

    // MARK: - requestWeatherData -

    func testRequestWeatherDataExecutesRequest() async {
        // given
        httpRequester.stubbedResult = (Data(), URLResponse())

        // when
        _ = await sut.requestWeatherData()

        // then
        XCTAssertTrue(httpRequester.invokedDataCounter == 1, "Requst was not executed")
    }

    func testRequestWeatherDataSuccess() async {
        // given
        httpRequester.stubbedResult = (JsonLoader.json(from: "WeatherResponse")!, URLResponse())

        // when
        let weatherData = try! await sut.requestWeatherData().get()

        // then
        XCTAssertTrue(weatherData.temperature == 2.0, "Temperature is incorrect")
        XCTAssertTrue(weatherData.type == .rain, "Weather type is incorrect")
    }

    func testRequestWeatherDataFailure() async {
        // given
        httpRequester.stubbedResult = (Data(), URLResponse())

        // when
        let weatherDataResult = await sut.requestWeatherData()

        // then
        guard case .failure(.network) = weatherDataResult else {
            XCTFail("Incorrect result: \(weatherDataResult)")
            return
        }
        // If we are here test has succeeded
    }
}
