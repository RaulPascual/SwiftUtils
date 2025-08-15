//
//  CombinedChartTests.swift
//
//
//  Created by Raul on 28/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class CombinedChartTests: XCTestCase {
    func testCombinedChartTests() {
        let view = CombinedBarChartView(
            racePointsData: [
                RacePointsData(round: "1", raceName: "Bahrain", points: 18.0),
                RacePointsData(round: "2", raceName: "Saudi Arabia", points: 25.0),
                RacePointsData(round: "3", raceName: "Australia", points: 15.0),
                RacePointsData(round: "4", raceName: "Azerbaijan", points: 10.0),
                RacePointsData(round: "5", raceName: "Miami", points: 12.0),
                RacePointsData(round: "6", raceName: "Monaco", points: 8.0),
                RacePointsData(round: "7", raceName: "Spain", points: 25.0),
                RacePointsData(round: "8", raceName: "Canada", points: 18.0)
            ],
            barColor: .green,
            chartTitle: LocalizedStringKey(stringLiteral: "Season progression")
        )
        assertSnapshot(of: view,
                       as: .wait(for: 3, on: .image(precision: 1, layout: .device(config: .iPhone13Pro))))
    }
}
