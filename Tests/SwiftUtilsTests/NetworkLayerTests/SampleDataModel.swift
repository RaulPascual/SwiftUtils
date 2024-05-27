//
//  SampleDataModel.swift
//
//
//  Created by Raul on 27/5/24.
//

import Foundation

// MARK: - Races Sample Data Model
struct Races: Codable {
    let races: [Race]?
}

// MARK: - Race
struct Race: Codable {
    let name, location: String?
    let latitude, longitude: Double?
    let round: Int?
    let slug, localeKey: String?
    let sessions: Sessions?
}

// MARK: - Sessions
struct Sessions: Codable {
    let practice, qualifying, sprint, feature: Date?
}
