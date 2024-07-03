//
//  DotsLoaderView.swift
//
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

/**
 A view representing a dots loader animation with customizable appearance.

 - Parameters:
    - color: The color of the dots. Default is blue.
    - dotCount: The number of dots in the loader. Default is 5.
    - maxScale: The maximum scale factor for the dots during animation. Default is 1.0.

 - Note: This view animates a series of dots to indicate loading or progress.
 */
public struct DotsLoaderView: View {
    @State private var isAnimating: Bool = false
    var color: Color = .blue
    var dotCount: Int = 5
    var maxScale: CGFloat = 1.0
    
    public init(isAnimating: Bool, color: Color, dotCount: Int, maxScale: CGFloat = 1.0) {
        self.isAnimating = isAnimating
        self.color = color
        self.dotCount = dotCount
        self.maxScale = maxScale
    }
    
    public var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<dotCount, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: 10, height: 10)
                    .scaleEffect(isAnimating ? 0.5 : maxScale)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
                    .padding(maxScale * 2.5)
            }
        }
        .onAppear {
            self.isAnimating = true
        }
    }
}

#Preview("Dots") {
    DotsLoaderView(isAnimating: true, color: .red, dotCount: 5, maxScale: 2)
}
