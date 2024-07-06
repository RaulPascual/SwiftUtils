//
//  SearchBar.swift
//
//
//  Created by Raul on 5/7/24.
//

import SwiftUI

/**
 A customizable search bar view.

 - Parameters:
    - text: A binding to the text input by the user.
    - placeholder: The placeholder text displayed when the search bar is empty.
    - icon: The icon displayed in the search bar. Default is a magnifying glass system image.
    - iconPosition: The position of the icon in the search bar. Default is `.leading`.
    - borderRadius: The corner radius of the search bar. Default is 8.
    - borderColor: The color of the search bar's border. Default is gray with 0.3 opacity.
    - borderWidth: The width of the search bar's border. Default is 2.
    - backgroundColor: The background color of the search bar. Default is gray with 0.2 opacity.

 - Note: The `IconPosition` enumeration defines different positions for the icon within the search bar.
 */
public struct SearchBar: View {
    @Binding var text: String
    var placeholder: String
    var icon: Image = Image(systemName: "magnifyingglass")
    var iconPosition: IconPosition = .leading
    var borderRadius: CGFloat = 8
    var borderColor: Color = .gray.opacity(0.3)
    var borderWidth: CGFloat = 2
    var backgroundColor: Color = .gray.opacity(0.2)
    
    public init(
        text: Binding<String>,
        placeholder: String,
        icon: Image = Image(systemName: "magnifyingglass"),
        iconPosition: IconPosition = .leading,
        borderRadius: CGFloat = 8,
        borderColor: Color = .gray.opacity(0.3),
        borderWidth: CGFloat = 2,
        backgroundColor: Color = .gray.opacity(0.2)
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.iconPosition = iconPosition
        self.borderRadius = borderRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        HStack {
            if iconPosition == .leading {
                icon
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
            }
            
            TextField("", text: $text, prompt: Text(placeholder).bold())
            
            if iconPosition == .trailing {
                icon
                    .foregroundColor(.gray)
                    .padding(.trailing, 8)
            }
        }
        .padding(8)
        .background(backgroundColor)
        .cornerRadius(borderRadius)
        .overlay(
            RoundedRectangle(cornerRadius: borderRadius)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .padding(.horizontal)
    }
}

public enum IconPosition {
    case leading
    case trailing
}

struct ExampleSearchBar: View {
    @State var text = ""
    var body: some View {
        SearchBar(
            text: $text,
            placeholder: "Search something",
            icon: Image(systemName: "magnifyingglass"),
            iconPosition: .leading,
            borderRadius: 8,
            borderColor: .gray.opacity(0.3),
            borderWidth: 2,
            backgroundColor: .gray.opacity(0.2)
        )
    }
}

#Preview {
    ExampleSearchBar()
}
