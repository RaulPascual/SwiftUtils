//
//  Checkbox.swift
//  
//
//  Created by Raul on 17/6/24.
//

import SwiftUI

/**
 A view representing a customizable checkbox with an optional error message.

 - Parameters:
    - isChecked: A binding to a boolean value indicating whether the checkbox is checked.
    - label: The text label displayed next to the checkbox.
    - errorText: An optional error message displayed when there is an error. Default is an empty string.
    - checkBoxSelectedColor: The color of the checkbox when it is selected. Default is blue.
    - checkBoxUnselectedColor: The color of the checkbox when it is unselected. Default is black.
    - size: The size of the checkbox. Default is 20.
    - showError: A binding to a boolean value indicating whether to show the error message.

 - Note: The view uses a custom `CheckboxToggleStyle` to style the checkbox.
 */
struct Checkbox: View {
    @Binding var isChecked: Bool
    var label: String
    var errorText: String = ""
    var checkBoxSelectedColor: Color = .blue
    var checkBoxUnselectedColor: Color = .black
    var size: CGFloat = 20
    @Binding var showError: Bool

    var body: some View {
        Toggle(isOn: $isChecked) {
            Text(label)
        }
        .toggleStyle(CheckboxToggleStyle(selectedColor: checkBoxSelectedColor,
                                         unselectedColor: checkBoxUnselectedColor,
                                         size: size,
                                         errorText: errorText, 
                                         showError: $showError))
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    var selectedColor: Color
    var unselectedColor: Color
    var size: CGFloat = 20
    var errorText: String = ""
    @Binding var showError: Bool
    
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(configuration.isOn ? selectedColor : unselectedColor)
                configuration.label
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
            
            VStack(alignment: .leading){
                if showError {
                    Text(errorText)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}

struct ExampleCheckBoxView: View {
    @State var isChecked = false
    @State var showError = true
    var body: some View {
        Checkbox(isChecked: $isChecked,
                 label: "Read terms and conditions",
                 errorText: "Please accept terms and conditions",
                 showError: $showError)
        .padding()
        
        Button {
            self.showError.toggle()
        } label: {
            Text("Show error")
        }
        .padding()
    }
}

#Preview {
    ExampleCheckBoxView()
}
