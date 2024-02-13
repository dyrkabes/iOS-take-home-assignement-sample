//
//  DemoLocationService.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 25.01.24.
//

import Combine

final class DemoLocationService: LocationServicing {
    var currentLocation: AnyPublisher<LocationState, Never> {
        _currentLocation.eraseToAnyPublisher()
    }

    private let _currentLocation = CurrentValueSubject<LocationState, Never>(.loaded(coordinate: Constants.coordinates[0]))

    private let updateDelay: Duration
    private var currentCoordinateIndex = 0
    private var updateLocationTask: Task<Void, Never>?

    init(updateDelay: Duration = Constants.delay) {
        self.updateDelay = updateDelay
    }

    func start() {
        guard updateLocationTask == nil else {
            return
        }
        updateLocationTask = Task {
            while true {
                try? await Task.sleep(for: updateDelay)
                do {
                    try updateLocationIfNotCancelled()
                } catch {
                    return
                }
            }
        }
    }

    private func updateLocationIfNotCancelled() throws {
        try Task.checkCancellation()
        currentCoordinateIndex = (currentCoordinateIndex + 1) % Constants.coordinates.count
        _currentLocation.send(.loaded(coordinate: Constants.coordinates[currentCoordinateIndex]))
    }

    func stop() {
        updateLocationTask?.cancel()
        updateLocationTask = nil
    }
}

private extension DemoLocationService {
    enum Constants {
        static let coordinates = [
            (53.619653, 10.079969),
            (53.080917, 8.847533),
            (52.378385, 9.794862),
            (52.496385, 13.444041),
            (53.866865, 10.739542),
            (54.304540, 10.152741),
            (54.797277, 9.491039),
            (52.426412, 10.821392),
            (53.542788, 8.613462),
            (53.141598, 8.242565),
        ]
        .map(Coordinate.init)

        static let delay = Duration.seconds(10)
    }
}
