//
//  DemoLocationServiceTest.swift
//  WeatherCatTests
//
//  Created by Pavel Stepanov on 27.01.24.
//

import Combine
import XCTest

@testable import WeatherCat

final class DemoLocationServiceTest: XCTestCase {
    private var sut: DemoLocationService!
    private var cancellable: AnyCancellable!

    override func setUp() {
        super.setUp()
        sut = .init()
    }

    // MARK: - Initially -

    func testLocationStateInitiallyIsLoaded() {
        // given
        var receivedLocationState: LocationState!
        cancellable = sut.currentLocation.sink(receiveValue: { receivedLocationState = $0 })

        // when && then
        guard case let .loaded(coordinate) = receivedLocationState else {
            XCTFail("Incorrect state")
            return
        }

        let expectedCoordinate = Coordinate(latitude: 53.619653, longitude: 10.079969)
        XCTAssertEqual(coordinate, expectedCoordinate)
    }

    func testLocationStateOnStartIsLoaded() {
        // given
        var receivedLocationState: LocationState!
        cancellable = sut.currentLocation.sink(receiveValue: { receivedLocationState = $0 })

        // when
        sut.start()

        // then
        guard case let .loaded(coordinate) = receivedLocationState else {
            XCTFail("Incorrect state")
            return
        }

        let expectedCoordinate = Coordinate(latitude: 53.619653, longitude: 10.079969)
        XCTAssertEqual(coordinate, expectedCoordinate)
    }

    func testStartDoesNotPublishAdditionalLocation() {
        // given
        var receivedLocationStates = [LocationState]()
        cancellable = sut.currentLocation.sink(receiveValue: { receivedLocationStates.append($0) })

        // when
        sut.start()

        // then
        XCTAssertEqual(receivedLocationStates.count, 1)
    }

    // MARK: - Delay tests -

    func testCurrentLocationIsChangedAfterDelayLazyApproach() {
        // given
        let expectation = XCTestExpectation(description: "Second location value should have been Publishd")

        var receivedLocationState: LocationState!
        cancellable = sut.currentLocation
            .dropFirst()
            .sink(receiveValue: {
                receivedLocationState = $0
                expectation.fulfill()
            })

        // when
        sut.start()

        // then
        wait(for: [expectation], timeout: 11.0)
        guard case let .loaded(coordinate) = receivedLocationState else {
            XCTFail("Incorrect state")
            return
        }

        let expectedCoordinate = Coordinate(latitude: 53.080917, longitude: 8.847533)
        XCTAssertEqual(coordinate, expectedCoordinate)
    }

    func testCurrentLocationIsChangedAfterDelayLessLazyApproach() {
        // given
        sut = .init(updateDelay: .milliseconds(10))
        let expectation = XCTestExpectation(description: "Second location value should have been Publishd")

        var receivedLocationState: LocationState!
        cancellable = sut.currentLocation
            .dropFirst()
            .sink(receiveValue: {
                receivedLocationState = $0
                expectation.fulfill()
            })

        // when
        sut.start()

        // then
        wait(for: [expectation], timeout: 1.0)
        guard case let .loaded(coordinate) = receivedLocationState else {
            XCTFail("Incorrect state")
            return
        }

        let expectedCoordinate = Coordinate(latitude: 53.080917, longitude: 8.847533)
        XCTAssertEqual(coordinate, expectedCoordinate)
    }

    // MARK: - Stop -

    func testLocationUpdatesAreStopped() {
        // given
        sut = .init(updateDelay: .milliseconds(10))
        var receivedLocationStates = [LocationState]()
        cancellable = sut.currentLocation
            .dropFirst()
            .sink(receiveValue: {
                receivedLocationStates.append($0)
            })
        sut.start()

        // when
        sut.stop()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 2 seconds")], timeout: 2.0)

        // then
        XCTAssertEqual(receivedLocationStates.count, 0)
    }
}
