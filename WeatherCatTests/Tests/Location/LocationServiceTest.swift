//
//  LocationServiceTest.swift
//  WeatherCatTests
//
//  Created by Pavel Stepanov on 27.01.24.
//

import Combine
import XCTest
@testable import WeatherCat

final class LocationServiceTest: XCTestCase {
    private var sut: LocationService!
    private var cancellable: AnyCancellable!

    override func setUp() {
        super.setUp()
        self.sut = .init()
    }

    // MARK: - Initially -

    func testSharesLocationInitially() {
        // given
        var receivedLocationData: LocationData!
        cancellable = sut.currentLocation.sink(receiveValue: { receivedLocationData = $0 })

        // when
        sut.start()

        // then
        XCTAssertNotNil(receivedLocationData)
    }

    func testInitialLocationIsCorrect() {
        // given
        var receivedLocationData: LocationData!
        cancellable = sut.currentLocation.sink(receiveValue: { receivedLocationData = $0 })

        // when
        sut.start()

        // then
        let expectedLocationData = LocationData(latitude: 53.619653, longitude: 10.079969)
        XCTAssertEqual(receivedLocationData, expectedLocationData)
    }

    // MARK: - Lazy Delay tests -

    func testCurrentLocationIsChangedAfterDelayLazyApproach() {
        // given
        let expectation = XCTestExpectation(description: "Second location value should have been shared")

        var receivedLocationData: LocationData!
        cancellable = sut.currentLocation
            .dropFirst()
            .sink(receiveValue: {
                receivedLocationData = $0
                expectation.fulfill()
            })

        // when
        sut.start()

        // then
        wait(for: [expectation], timeout: 11.0)
        let expectedLocationData = LocationData(latitude: 53.080917, longitude: 8.847533)
        XCTAssertEqual(receivedLocationData, expectedLocationData)
    }

    func testCurrentLocationIsChangedAfterDelayLessLazyApproach() {
        // given
        sut = .init(updateDelay: .milliseconds(10))
        let expectation = XCTestExpectation(description: "Second location value should have been shared")

        var receivedLocationData: LocationData!
        cancellable = sut.currentLocation
            .dropFirst()
            .sink(receiveValue: {
                receivedLocationData = $0
                expectation.fulfill()
            })

        // when
        sut.start()

        // then
        wait(for: [expectation], timeout: 1.0)
        let expectedLocationData = LocationData(latitude: 53.080917, longitude: 8.847533)
        XCTAssertEqual(receivedLocationData, expectedLocationData)
    }
}
