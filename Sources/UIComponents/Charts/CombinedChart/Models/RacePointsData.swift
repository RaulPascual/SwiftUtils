//
//  RacePointsData.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 15/8/25.
//

import Foundation

struct RacePointsData: Identifiable, Hashable {
    let id = UUID()
    let round: String
    let raceName: String
    let points: Double
}

enum ChartType {
    case bar
    case line
}
