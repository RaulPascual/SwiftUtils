//
//  PieChartView.swift
//  
//
//  Created by Raul on 28/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class PieChartView: XCTestCase {
    func testPieChartView() {
        let view = GenericPieChartView(
            data: [
                PieChartDataItem(label: "PIA", value: 266.0, color: .orange, subtitle: "(52.1%)"),
                PieChartDataItem(label: "NOR", value: 245.0, color: .orange.opacity(0.6), subtitle: "(47.9%)")
            ],
            centerLabel: "Pts",
            centerValue: "511",
            centerValueColor: .orange,
            showSideCards: true
        )
        assertSnapshot(of: view,
                       as: .wait(for: 3, on: .image(precision: 1, layout: .device(config: .iPhone13Pro))))
    }
}
