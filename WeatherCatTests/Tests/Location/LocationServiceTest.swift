//
//  LocationServiceTest.swift
//  WeatherCatTests
//
//  Created by Pavel Stepanov on 13.02.24.
//

import Combine
import CoreLocation
import XCTest

@testable import WeatherCat

final class LocationServiceTest: XCTestCase {
    private var sut: LocationService!
    private var locationProvider: LocationProviderSpy!
    private var cancellables = Set<AnyCancellable>()
    private let stubbedCLLocationManager = CLLocationManager()
    private let stubbedError = NSError(domain: "some domain", code: -1)

    override func setUp() {
        super.setUp()
        locationProvider = .init()
        sut = .init(locationProvider: locationProvider)
    }

    // MARK: - Start and Stop -

    func testStartStartsLocationProvider() {
        // given && when
        sut.start()

        // then
        XCTAssertTrue(locationProvider.stubbedDelegate === sut)
        XCTAssertEqual(locationProvider.invokedStartUpdatingLocationCount, 1)
    }

    func testStartStartsLocationProviderOnlyOnce() {
        // given && when
        (0...9).forEach { _ in sut.start() }

        // then
        XCTAssertEqual(locationProvider.invokedStartUpdatingLocationCount, 1)
    }

    func testStopStopsLocationProvider() {
        // given && when
        sut.stop()

        // then
        XCTAssertEqual(locationProvider.invokedStopUpdatingLocationCount, 1)
    }

    func testProviderStartsAfterStop() {
        // given
        sut.start()
        sut.stop()

        // when
        sut.start()

        // then
        XCTAssertEqual(locationProvider.invokedStartUpdatingLocationCount, 2)
    }

    // MARK: - current location -

    func testLocationStateIsLoadingInitially() {
        // given
        var locationState: LocationState!

        // when
        sut.currentLocation
            .sink(receiveValue: { locationState = $0 })
            .store(in: &cancellables)

        // then
        guard case .loading = locationState else {
            XCTFail("Incorrect state: \(String(describing: locationState))")
            return
        }
    }

    func testLocationIsLoadedWhenUpdated() {
        // given
        var locationState: LocationState!
        sut.currentLocation
            .sink(receiveValue: { locationState = $0 })
            .store(in: &cancellables)

        // when
        let updatedLocation = CLLocation(latitude: 41.303921, longitude: -81.901693)
        sut.locationManager(stubbedCLLocationManager, didUpdateLocations: [updatedLocation])

        // then
        guard case let .loaded(coordinate) = locationState else {
            XCTFail("Incorrect state: \(String(describing: locationState))")
            return
        }
        XCTAssertEqual(coordinate.latitude, updatedLocation.coordinate.latitude)
        XCTAssertEqual(coordinate.longitude, updatedLocation.coordinate.longitude)
    }

    func testLocationIsNotUpdated() {
        // given
        var locationState: LocationState!
        sut.currentLocation
            .sink(receiveValue: { locationState = $0 })
            .store(in: &cancellables)

        // when
        sut.locationManager(stubbedCLLocationManager, didFailWithError: stubbedError)

        // then
        guard case .error = locationState else {
            XCTFail("Incorrect state: \(String(describing: locationState))")
            return
        }
    }
}
