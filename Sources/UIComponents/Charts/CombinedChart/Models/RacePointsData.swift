//
//  RacePointsData.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 15/8/25.
//

import Foundation

public struct RacePointsData: Identifiable, Hashable {
    public let id = UUID()
    let round: String
    let raceName: String
    let points: Double
    
    public init(round: String, raceName: String, points: Double) {
        self.round = round
        self.raceName = raceName
        self.points = points
    }
}

public enum ChartType {
    case bar
    case line
}
