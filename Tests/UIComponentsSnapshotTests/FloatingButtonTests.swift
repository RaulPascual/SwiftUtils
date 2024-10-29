//
//  SlidingTabView.swift
//
//
//  Created by Raul on 21/5/24.
//

import SwiftUI
import XCTest
import SnapshotTesting

@testable import UIComponents

@MainActor
final class FloatingButtonTests: XCTestCase {
    func testFloatingButton() {
        let view = FloatingButtonExample()
        
        assertSnapshot(of: view,
                       as: .image(precision: 0.97, layout: .device(config: .iPhone13Pro)))
    }
}

struct FloatingButtonExample: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                Text(sampleText)
                    .padding()
            }
            
            FloatingButton(image: Image(systemName: "plus"),
                           backgroundColor: .blue.opacity(0.8),
                           foregroundColor: .white,
                           size: 30,
                           position: .bottomRight,
                           clipShape: Circle()) {
                print("Button example action!!")
            }
        }
    }
}
