//
//  File.swift
//
//
//  Created by Raul on 18/6/24.
//

import SwiftUI

/**
 A customizable text field view with various configuration options.

 - Parameters:
    - text: A binding to the text input by the user.
    - placeholder: A placeholder text displayed when the text field is empty. Default is an empty Text.
    - keyboardType: The type of keyboard to display when the text field is active. Default is `.default`.
    - charactersLimit: An optional limit on the number of characters that can be entered. Default is nil.
    - borderColor: An optional color for the border of the text field. Default is the separator color.

 - Note: The view uses SwiftUI's `TextField` and applies the specified configurations.
 */
public struct CustomTextField: View {
    @Binding var text: String
    var placeholder: Text = Text("")
    var keyboardType: UIKeyboardType = .default
    var charactersLimit: Int? = nil
    var borderColor: Color? = Color(UIColor.separator)
    
    public init(text: Binding<String>, placeholder: Text,
                keyboardType: UIKeyboardType = .default, charactersLimit: Int? = nil,
                borderColor: Color? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.charactersLimit = charactersLimit
        self.borderColor = borderColor
    }
    
    public var body: some View {
        TextField("", text: $text, prompt: placeholder, axis: .vertical)
            .keyboardType(keyboardType)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor ?? .clear, lineWidth: 1)
            )
            .onChange(of: text) { _, newValue in
                if let limit = charactersLimit, newValue.count > limit {
                    text = String(newValue.prefix(limit))
                }
            }
    }
}

struct ExampleCustomTextfieldView: View {
    @State var text = ""
    var body: some View {
        CustomTextField(text: $text,
                        placeholder: Text("Placeholder"),
                        borderColor: .cyan)
        .validate(with: "^[a-zA-Z0-9]*$", text: $text)
    }
}

#Preview {
    ExampleCustomTextfieldView()
        .padding()
}
