//
//  CustomSheet.swift
//
//
//  Created by Raul on 20/5/24.
//
import SwiftUI

/**
 A custom view modifier for presenting a sheet with configurable properties.
 - Parameters:
 - isPresented: A binding to a boolean that indicates whether the sheet is presented.
 - backgroundColor: The background color of the sheet.
 - presentationDetents: A set of presentation detents to determine the sheet's size and behavior.
 - showDragIndicator: The visibility of the drag indicator on the sheet.
 - cornerRadius: The corner radius of the sheet.
 - dismissAction: An optional closure to execute when the sheet is dismissed.
 - content: A closure returning the content to be displayed in the sheet.
 
 - Note: This view modifier can be used to present a sheet with customizable appearance and behavior.
 */
public struct CustomSheet<SimpleContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var backgroundColor: Color
    var presentationDetents: Set<PresentationDetent>
    var showDragIndicator: Visibility
    var cornerRadius: CGFloat
    var dismissAction: (() -> Void)?
    let content: () -> SimpleContent
    
    public init(
        isPresented: Binding<Bool>,
        backgroundColor: Color,
        presentationDetents: Set<PresentationDetent>,
        showDragIndicator: Visibility,
        cornerRadius: CGFloat,
        dismissAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SimpleContent
    ) {
        self._isPresented = isPresented
        self.backgroundColor = backgroundColor
        self.presentationDetents = presentationDetents
        self.showDragIndicator = showDragIndicator
        self.cornerRadius = cornerRadius
        self.dismissAction = dismissAction
        self.content = content
    }
    
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented, onDismiss: {
                if let dismissAction {
                    dismissAction()
                }
            }, content: {
                if #available(iOS 16.4, *) {
                    VStack {
                        self.content()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .presentationDetents(presentationDetents) // Sheet size
                    .presentationDragIndicator(showDragIndicator)
                    .presentationBackground(backgroundColor) // Better to use this to a background color because in case of displaying the indicator, it adapts to the background color.
                    .presentationCornerRadius(cornerRadius) // Sheet corder radius
                    
                } else {
                    // iOS 16.4 and below
                    VStack {
                        self.content()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .presentationDetents(presentationDetents) // Sheet size
                    .presentationDragIndicator(showDragIndicator)
                    .background(backgroundColor)
                }
            })
    }
}

#Preview {
    VStack {
        Text("Hello!")
            .customSheet(isPresented: .constant(true),
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
