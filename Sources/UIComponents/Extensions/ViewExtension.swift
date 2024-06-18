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
    
    /**
     Adds custom accessibility properties to a view.
     
     - Parameters:
     - label: An optional accessibility label for the view. Default is nil.
     - hint: An optional accessibility hint for the view. Default is nil.
     - traits: Optional accessibility traits for the view. Default is nil.
     
     - Returns: A view modified with the specified accessibility properties.
     */
    public func customAccessibility(label: String? = nil, hint: String? = nil, traits: AccessibilityTraits? = nil) -> some View {
        accessibilityLabel(label ?? "")
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits ?? [])
    }
    
    func validate(with regexPattern: String, text: Binding<String>) -> some View {
        self.modifier(RegexValidator(text: text, regexPattern: regexPattern))
    }
    
    // MARK: - Scroll Transitions
    public func scrollTransition() -> some View {
        self.modifier(ScrollTransitionModifier())
    }
    
    public func scaleAndOpacityTransition() -> some View {
        self.modifier(ScaleAndOpacityTransitionModifier())
    }
    
    public func combinedTransition() -> some View {
        self.modifier(CombinedTransitionModifier())
    }
    
}
