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
}
