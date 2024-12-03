//
//  ExperimentalFeatureView.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 3/12/24.
//

import SwiftUI

public struct ExperimentalFeatureView: View {
    let icon: Image
    let message: LocalizedStringKey
    let foregroundColor: Color? = .white
    let backgroundColor: Color? = .orange
    
    public init(icon: Image, message: LocalizedStringKey) {
        self.icon = icon
        self.message = message
    }
    
    public var body: some View {
        HStack {
            icon
            Text(message.stringValue())
        }
        .padding()
        .foregroundStyle(foregroundColor ?? .white)
        .background {
            backgroundColor
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .opacity(0.8)
                .padding([.leading, .trailing], 10)
        }
    }
}

#Preview {
    ExperimentalFeatureView(icon: Image(systemName: "exclamationmark.bubble.fill"),
                            message: LocalizedStringKey("Experimental Feature"))
}
