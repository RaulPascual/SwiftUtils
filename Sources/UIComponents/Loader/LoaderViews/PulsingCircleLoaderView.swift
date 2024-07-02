//
//  PulsingCircleLoaderView.swift
//
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

public struct PulsingCircleLoaderView: View {
    @State private var isAnimating: Bool = false
    var color: Color = .blue

    public init(isAnimating: Bool, color: Color) {
        self.isAnimating = isAnimating
        self.color = color
    }
    
    public var body: some View {
        Circle()
            .fill(color)
            .frame(width: 50, height: 50)
            .scaleEffect(isAnimating ? 1.0 : 0.5)
            .opacity(isAnimating ? 1.0 : 0.5)
            .animation(
                Animation
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                self.isAnimating = true
            }
    }
}

#Preview("PulsingCircleLoaderView") {
    PulsingCircleLoaderView(isAnimating: true, color: .blue)
}
