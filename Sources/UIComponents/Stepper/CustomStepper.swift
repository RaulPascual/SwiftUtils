//
//  CustomStepper.swift
//
//
//  Created by Raul on 7/7/24.
//

import SwiftUI

/**
 A customizable stepper view for incrementing and decrementing a value.

 - Parameters:
    - value: A binding to a double value representing the current value of the stepper.
    - increment: The amount by which to increment or decrement the value.
    - range: The closed range within which the value can be incremented or decremented.
    - buttonSize: The size of the increment and decrement buttons. Default is 20.
    - stepperColor: The color of the stepper buttons. Default is blue.
    - font: The font of the value text. Default is system title2.

 - Note: The `CustomStepper` view allows for adjusting a numeric value within a specified range using increment and decrement buttons.
 */
public struct CustomStepper: View {
    @Binding var value: Double
    var increment: Double
    var range: ClosedRange<Double>
    var buttonSize: CGFloat
    var stepperColor: Color
    var font: Font
    
    public init(
        value: Binding<Double>,
        increment: Double,
        range: ClosedRange<Double>,
        buttonSize: CGFloat = 20,
        stepperColor: Color = .blue,
        font: Font = .system(.title2)
    ) {
        self._value = value
        self.increment = increment
        self.range = range
        self.buttonSize = buttonSize
        self.stepperColor = stepperColor
        self.font = font
    }
    
    public var body: some View {
        HStack {
            Button(action: {
                if value > range.lowerBound {
                    value = max(value - increment, range.lowerBound)
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(value > range.lowerBound ? stepperColor : .gray)
                    .font(.system(size: buttonSize))
            }
            .disabled(value <= range.lowerBound)
            
            Text(String(format: "%.2f", value))
                .padding(.horizontal, 20)
                .font(font)
            
            Button(action: {
                if value < range.upperBound {
                    value = min(value + increment, range.upperBound)
                }
            }) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(value < range.upperBound ? stepperColor : .gray)
                    .font(.system(size: buttonSize))
            }
            .disabled(value >= range.upperBound)
        }
        .padding()
    }
}

struct ExampleCustomStepper: View {
    @State private var stepperValue: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Custom Stepper")
                .font(.largeTitle)
                .padding()
            CustomStepper(value: $stepperValue, increment: 0.1, range: 0.0...1.0)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ExampleCustomStepper()
}
