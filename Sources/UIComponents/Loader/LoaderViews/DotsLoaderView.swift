//
//  DotsLoaderView.swift
//
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

public struct DotsLoaderView: View {
    @State private var isAnimating: Bool = false
    var color: Color = .blue
    var dotCount: Int = 5
    
    public init(isAnimating: Bool, color: Color, dotCount: Int) {
        self.isAnimating = isAnimating
        self.color = color
        self.dotCount = dotCount
    }

    public var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                    .scaleEffect(isAnimating ? 0.5 : 1.0)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}

#Preview("Dots") {
    DotsLoaderView(isAnimating: true, color: .red, dotCount: 5)
}
