//
//  ScrollTransitions.swift
//
//
//  Created by Raul on 2/6/24.
//

import SwiftUI


public struct ScrollTransitionModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.scrollTransition { effect, phase in
            effect
                .scaleEffect(phase.isIdentity ? 1 : 0.85)
        }
    }
}

public struct ScaleAndOpacityTransitionModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.scrollTransition { effect, phase in
            effect
                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                .opacity(phase.isIdentity ? 1 : 0.5)
        }
    }
}

public struct CombinedTransitionModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.scrollTransition { effect, phase in
            effect
                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                .opacity(phase.isIdentity ? 1 : 0.5)
                .rotationEffect(.degrees(phase.isIdentity ? 0 : 15))
        }
    }
}
