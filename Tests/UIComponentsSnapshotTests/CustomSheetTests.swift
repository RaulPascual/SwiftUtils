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

final class CustomSheetTests: XCTestCase {
    func testCustomSheet() {
        let view = CustomSheetView
        assertSnapshot(of: view,
                       as: .wait(for: 3, on: .image(precision: 1, layout: .device(config: .iPhone13Pro))))
    }
}

var CustomSheetView: some View {
    @State var presented = true
    return VStack {
        Text("Hello!")
            .customSheet(isPresented: $presented,
                         backgroundColor: .gray,
                         presentationDetents: [.medium],
                         showDragIndicator: .visible,
                         cornerRadius: 16) {
                print("Dismiss action")
            } content: {
                VStack {
                    Text("Half modal content")
                }
            }
    }
}
