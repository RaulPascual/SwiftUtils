//
//  ViewExtension.swift
//
//
//  Created by Raul on 20/5/24.
//

import SwiftUI

extension View {
    public func customSheet<SimpleContent: View>(
           isPresented: Binding<Bool>,
           backgroundColor: Color? = Color.white,
           presentationDetents: Set<PresentationDetent>,
           showDragIndicator: Visibility? = .visible,
           cornerRadius: CGFloat? = 16,
           dismissAction: (() -> Void)? = nil,
           @ViewBuilder content: @escaping () -> SimpleContent) -> some View {
               self.modifier(CustomSheet(
                   isPresented: isPresented,
                   backgroundColor: backgroundColor ?? Color.white,
                   presentationDetents: presentationDetents,
                   showDragIndicator: showDragIndicator ?? .visible,
                   cornerRadius: cornerRadius ?? 16,
                   dismissAction: dismissAction,
                   content: content))
           }
    
    public func customAccessibility(label: String? = nil, hint: String? = nil, traits: AccessibilityTraits? = nil) -> some View {
        accessibilityLabel(label ?? "")
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits ?? [])
    }
    
    
    // MARK: - Scroll Transitions
    public func scrollTransition() -> some View {
        self.modifier(ScrollTransitionModifier())
    }
    
    public func scaleAndOpacityTranstion() -> some View {
        self.modifier(ScaleAndOpacityTransitionModifier())
    }
    
    public func combinedTranstion() -> some View {
        self.modifier(CombinedTransitionModifier())
    }
    
}
