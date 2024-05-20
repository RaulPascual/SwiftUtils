//
//  SlidingTabView.swift
//
//
//  Created by Raul on 20/5/24.
//

import SwiftUI

/**
   A custom view that displays a sliding tab view with selectable tabs and a sliding selection indicator.

   - Parameters:
      - selectionState: The initial state of the selected tab index.
      - selection: A binding to the currently selected tab index.
      - tabs: An array of strings representing the tab titles.
      - activeAccentColor: The color of the text for the active tab. Defaults to blue.
      - inactiveAccentColor: The color of the text for inactive tabs. Defaults to gray.
      - selectionBarColor: The color of the selection bar. Defaults to green.
      - inactiveTabColor: The background color of inactive tabs.
      - activeTabColor: The background color of the active tab.
      - selectionBarHeight: The height of the selection bar. Defaults to 3.
      - selectionBarBackgroundColor: The background color of the selection bar area. Defaults to a gray with 20% opacity.
      - selectionBarBackgroundHeight: The height of the selection bar background. Defaults to 3.
   
   - Note: The `SlidingTabView` provides a user interface element for switching between different tabs, with a sliding indicator to show the currently selected tab.
*/
public struct SlidingTabView: View {
    // MARK: Internal State
    
    /// Internal state to keep track of the selection index
    @State private var selectionState: Int = 0 {
        didSet {
            selection = selectionState
        }
    }
    @Binding var selection: Int
    
    let tabs: [String]
    var activeAccentColor: Color = .blue
    var inactiveAccentColor: Color = .gray
    var selectionBarColor: Color = .green
    var inactiveTabColor: Color = .clear
    var activeTabColor: Color = .clear
    let selectionBarHeight: CGFloat = 3
    let selectionBarBackgroundColor = Color.gray.opacity(0.2)
    let selectionBarBackgroundHeight: CGFloat = 3
    
    public init(
        selectionState: Int,
        selection: Binding<Int>,
        tabs: [String],
        activeAccentColor: Color = .blue,
        inactiveAccentColor: Color = .gray,
        selectionBarColor: Color = .green,
        inactiveTabColor: Color,
        activeTabColor: Color
    ) {
        self.selectionState = selectionState
        self._selection = selection
        self.tabs = tabs
        self.activeAccentColor = activeAccentColor
        self.inactiveAccentColor = inactiveAccentColor
        self.selectionBarColor = selectionBarColor
        self.inactiveTabColor = inactiveTabColor
        self.activeTabColor = activeTabColor
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                ForEach(self.tabs, id: \.self) { tab in
                    Button {
                        let selection = self.tabs.firstIndex(of: tab) ?? 0
                        self.selectionState = selection
                    } label: {
                        HStack {
                            Spacer()
                            Text(tab)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                    }
                    .accessibilityAddTraits(self.getTraits(forTabIdentifier: tab))
                    .accessibility(label: Text(tab))
                    .padding(.vertical, 8)
                    .accentColor(
                        self.isSelected(tabIdentifier: tab)
                        ? self.activeAccentColor
                        : self.inactiveAccentColor)
                    .background(
                        self.isSelected(tabIdentifier: tab)
                        ? self.activeTabColor
                        : self.inactiveTabColor)
                }
            }
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle() // Rectangle for selected tab
                        .fill(self.selectionBarColor)
                        .padding([.leading, .trailing], 8)
                        .frame(width: self.tabWidth(from: geometry.size.width), height: self.selectionBarHeight, alignment: .leading)
                        .offset(x: self.selectionBarXOffset(from: geometry.size.width), y: 0)
                    
                    Rectangle() // General rectangle for all tabs
                        .fill(self.selectionBarBackgroundColor)
                        .frame(width: geometry.size.width, height: self.selectionBarBackgroundHeight, alignment: .leading)
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    // MARK: Private Helper
    
    private func isSelected(tabIdentifier: String) -> Bool {
        return tabs[selectionState] == tabIdentifier
    }
    
    private func selectionBarXOffset(from totalWidth: CGFloat) -> CGFloat {
        return self.tabWidth(from: totalWidth) * CGFloat(selectionState)
    }
    
    private func tabWidth(from totalWidth: CGFloat) -> CGFloat {
        return totalWidth / CGFloat(tabs.count)
    }
    
    private func getTraits(forTabIdentifier tabIdentifier: String) -> AccessibilityTraits {
        return self.tabs.firstIndex(of: tabIdentifier) == self.selectionState ? .isSelected : []
    }
}

#Preview {
    SlidingTabView(selectionState: 0,
                   selection: .constant(0),
                   tabs: ["Tab 1", "Tab 2", "Tab 3"],
                   inactiveTabColor: .gray,
                   activeTabColor: .blue)
}
