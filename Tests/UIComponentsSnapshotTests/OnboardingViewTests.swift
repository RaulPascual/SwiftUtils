//
//  OnboardingViewTests.swift
//
//
//  Created by Raul on 21/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class OnboardingViewTests: XCTestCase {
    func testOnboardingView() {
        let view = OnboardingView(primaryBackgroundColor: .blue,
                                  onboardViews: [OnBoardView(id: UUID(),
                                                             image: Image(systemName: "figure.soccer"),
                                                             title: "Title 1",
                                                             description: "Description of first view"),
                                                 OnBoardView(id: UUID(),
                                                             image: Image(systemName: "heart"),
                                                             title: "Title 2",
                                                             description: "Description of second view")])
        
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}
