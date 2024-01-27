//
//  LocationService.swift
//  WeatherCat
//
//  Created by Pavel Stepanov on 25.01.24.
//

import Combine
import CoreLocation

protocol LocationServicing {
    var currentLocation: AnyPublisher<LocationData, Never> { get }

    func start()
}

final class LocationService: LocationServicing {
    var currentLocation: AnyPublisher<LocationData, Never> {
        _currentLocation.eraseToAnyPublisher()
    }
    private let _currentLocation = CurrentValueSubject<LocationData, Never>(Constants.locations[0])

    private let updateDelay: Duration
    private var currentLocationIndex = 0

    init(updateDelay: Duration = Constants.delay) {
        self.updateDelay = updateDelay
    }

    func start() {
        Task {
            while true {
                try? await Task.sleep(for: updateDelay)

                currentLocationIndex = (currentLocationIndex + 1) % Constants.locations.count
                _currentLocation.send(Constants.locations[currentLocationIndex])
            }
        }
    }
}

private extension LocationService {
    enum Constants {
        static let locations = [
            (53.619653, 10.079969),
            (53.080917, 8.847533),
            (52.378385, 9.794862),
            (52.496385, 13.444041),
            (53.866865, 10.739542),
            (54.304540, 10.152741),
            (54.797277, 9.491039),
            (52.426412, 10.821392),
            (53.542788, 8.613462),
            (53.141598, 8.242565)
        ]
            .map(LocationData.init)

        static let delay = Duration.seconds(10)
    }
}
