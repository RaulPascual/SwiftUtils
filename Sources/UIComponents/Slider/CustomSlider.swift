//
//  SwiftUIView.swift
//
//
//  Created by Raul on 9/8/24.
//

import SwiftUI

/**
 A customizable slider view that allows for selecting a value within a specified range.

 - Parameters:
    - currentValue: A binding to the current value selected by the slider.
    - minValue: The minimum value of the slider's range.
    - maxValue: The maximum value of the slider's range.
    - step: The step increment for the slider. Default is `1.0`.
    - backgroundColor: The background color of the slider track. Default is `.blue`.
    - showButtons: A Boolean indicating whether to display increment and decrement buttons alongside the slider. Default is `false`.

 - Note: The `CustomSlider` provides a flexible way to control and display values within a range. You can customize the slider's appearance and behavior, including the ability to show buttons for step adjustments.
 */
public struct CustomSlider: View {
    @Binding var currentValue: Double
    
    var minValue: Double
    var maxValue: Double
    var step: Double = 1.0
    var backgroundColor: Color = .blue
    var showButtons: Bool = false
    
    public init(currentValue: Binding<Double>, minValue: Double, maxValue: Double, step: Double, backgroundColor: Color, showButtons: Bool = false) {
        self._currentValue = currentValue
        self.minValue = minValue
        self.maxValue = maxValue
        self.step = step
        self.backgroundColor = backgroundColor
        self.showButtons = showButtons
    }
    
    public var body: some View {
        VStack {
            HStack {
                if showButtons {
                    Button {
                        self.currentValue -= step
                    } label: {
                        Image(systemName: "minus")
                            .tint(backgroundColor)
                    }
                    .disabled(currentValue <= minValue)
                }
                
                Slider(
                    value: $currentValue,
                    in: minValue...maxValue,
                    step: step
                )
                .accentColor(backgroundColor)
                .padding()
                
                if showButtons {
                    Button {
                        self.currentValue += step
                    } label: {
                        Image(systemName: "plus")
                            .tint(backgroundColor)
                    }
                    .disabled(currentValue >= maxValue)
                }
            }
        }
        .padding()
    }
}

struct ExampleCustomSlider: View {
    @State private var sliderValue: Double = 50.0
    
    var body: some View {
        VStack {
            CustomSlider(
                currentValue: $sliderValue,
                minValue: 0,
                maxValue: 100,
                step: 1,
                backgroundColor: .green,
                showButtons: true
            )
            .padding()
            
            Text("Current value: \(sliderValue, specifier: "%.2f")")
                .font(.headline)
                .padding()
        }
    }
}

#Preview {
    ExampleCustomSlider()
}
