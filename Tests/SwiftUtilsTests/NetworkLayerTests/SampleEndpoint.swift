//
//  SampleEndpoint.swift
//
//
//  Created by Raul on 27/5/24.
//

import Foundation
import SwiftUtils

// MARK: - Sample Endpoint
enum CurrentCalendarEndpoint {
    case currentDriverStandings(year: String)
}

extension CurrentCalendarEndpoint: Endpoint {
    var baseURL: String {
        switch self {
        case .currentDriverStandings:
            return "https://github.com/sportstimes/f1"
        }
    }

    var path: String {
        var path = ""
        switch self {
        case .currentDriverStandings(let year):
            path = "blob/main/_db/f1/\(year)"
        }
        return path.appending(".json")
    }

    var method: RequestMethod { return .get }

    var header: [String: String]? { return ["Content-Type": "application/json"] }

    var body: String? { return nil }
}
