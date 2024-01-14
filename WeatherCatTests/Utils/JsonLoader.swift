//
//  JsonLoader.swift
//  WeatherCatTests
//
//  Created by Pavel Stepanov on 14.01.24.
//

import Foundation
import XCTest

final class JsonLoader {
    static func json(from file: String) -> Data? {
        let bundle = Bundle(for: self)
        guard let url = bundle.url(forResource: file, withExtension: "json") else {
            XCTFail("Missing file")
            return nil
        }

        guard let json = try? Data(contentsOf: url) else {
            XCTFail("Cannot parse json")
            return nil
        }

        return json
    }
}
