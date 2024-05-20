//
//  Hyperlink.swift
//
//
//  Created by Raul on 20/5/24.
//

import SwiftUI

public struct Hyperlink: View {
    let text: String
    let linkText: String
    let url: URL
    
    public init(text: String, linkText: String, url: URL) {
        self.text = text
        self.linkText = linkText
        self.url = url
    }
    
    public var body: some View {
        Text(makeAttributedString())
            .onTapGesture {
                openURL(url)
            }
    }
    
    private func makeAttributedString() -> AttributedString {
        var attributedString = AttributedString(text)
        if let range = attributedString.range(of: linkText) {
            attributedString[range].link = url
            attributedString[range].foregroundColor = .blue
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
        Hyperlink(text: "Visit the Apple website", linkText: "Apple", url: URL(string: "https://www.apple.com")!)
            .padding()
}
