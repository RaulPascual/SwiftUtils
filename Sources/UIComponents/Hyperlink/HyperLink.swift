//
//  Hyperlink.swift
//
//
//  Created by Raul on 20/5/24.
//

import SwiftUI
/**
 A view that displays a piece of text with an embedded hyperlink.
 - Parameters:
    - text: The main text to be displayed.
    - linkText: The text for the hyperlink.
    - url: The URL that the hyperlink points to.
    - urlForegroundColor: The color of the hyperlink text. Defaults to blue.
 
 - Note: The `Hyperlink` view allows for displaying text with an interactive hyperlink that navigates to the specified URL when clicked.
 */
public struct Hyperlink: View {
    let text: String
    let linkText: String
    let url: URL
    let urlForegroundColor: Color? = .blue
    
    public init(text: String, linkText: String, url: URL, urlForegroundColor: Color? = .blue) {
        self.text = text
        self.linkText = linkText
        self.url = url
    }
    
    public var body: some View {
        Text(makeAttributedString())
            .accessibilityAddTraits(.isLink)
            .onTapGesture {
                openURL(url)
            }
    }
    
    private func makeAttributedString() -> AttributedString {
        var attributedString = AttributedString(text)
        if let range = attributedString.range(of: linkText) {
            attributedString[range].link = url
            attributedString[range].foregroundColor = urlForegroundColor
            attributedString[range].underlineStyle = .single
        }
        return attributedString
    }
    
    private func openURL(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    Hyperlink(text: "Visit FormulaTracker app",
              linkText: "FormulaTracker",
              url: URL(string: "https://apps.apple.com/es/app/formula-tracker/id6446653054")!)
    .padding()
}
