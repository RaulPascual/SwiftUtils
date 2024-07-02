//
//  File.swift
//  
//
//  Created by Raul on 2/7/24.
//

import SwiftUI

public struct LoaderContainer: View {
    let type: LoaderType
    var color: Color = .blue
    var dotCount: Int? = 4
    
    public init(type: LoaderType, color: Color, dotCount: Int? = nil) {
        self.type = type
        self.color = color
        self.dotCount = dotCount
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .center)) {
                Rectangle()
                    .fill(Color.black.opacity(0.4))
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                VStack {
                    Spacer()
                    loaderView
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(.all)
    }

    @ViewBuilder
    private var loaderView: some View {
        switch type {
        case .circularProgress:
            CircularProgressLoaderView(color: color, scale: 1.5)
        case .dots:
            DotsLoaderView(isAnimating: true, color: color, dotCount: dotCount ?? 4)
        case .pulsingCircle:
            PulsingCircleLoaderView(isAnimating: true, color: color)
        case .custom(let customView):
            customView()
        }
    }
}

#Preview {
    LoaderContainer(type: .pulsingCircle, color: .red)
}
