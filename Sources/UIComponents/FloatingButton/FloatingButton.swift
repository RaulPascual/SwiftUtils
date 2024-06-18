//
//  FloatingButton.swift
//
//
//  Created by Raul on 25/5/24.
//

import SwiftUI

/**
 A customizable floating button view that can be positioned in various locations on the screen.

 - Parameters:
    - image: The image to be displayed on the button.
    - backgroundColor: The background color of the button.
    - foregroundColor: The color of the button's content.
    - size: The size of the button.
    - position: The position of the button on the screen.
    - clipShape: The shape used to clip the button.
    - action: The action to be performed when the button is pressed.

 - Example:
    ```
    FloatingButton(image: Image(systemName: "plus"),
                   backgroundColor: .blue,
                   foregroundColor: .white,
                   size: 50,
                   position: .bottomRight,
                   clipShape: Circle()) {
                       // Button action here
                   }
    ```
 */
public struct FloatingButton<S: Shape>: View {
    let image: Image
    let backgroundColor: Color
    let foregroundColor: Color
    let size: CGFloat
    let position: FloatingButtonPosition
    let clipShape: S
    var action: () -> Void
    
    public init(image: Image, backgroundColor: Color, foregroundColor: Color,
                size: CGFloat, position: FloatingButtonPosition,
                clipShape: S, action: @escaping () -> Void) {
        self.image = image
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.size = size
        self.position = position
        self.clipShape = clipShape
        self.action = action
    }
    
    public var body: some View {
        VStack {
            if isBottomPosition(position) {
                Spacer()
            }
            
            HStack {
                if isRightPosition(position) {
                    Spacer()
                }
                
                Button(action: {
                    action()
                }) {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .padding(8)
                }
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(clipShape)
                .padding()
                
                if isLeftPosition(position) {
                    Spacer()
                }
            }
            
            if isTopPosition(position) {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func isBottomPosition(_ position: FloatingButtonPosition) -> Bool {
        return position == .bottomLeft || position == .bottomCenter || position == .bottomRight
    }
    
    private func isTopPosition(_ position: FloatingButtonPosition) -> Bool {
        return position == .topLeft || position == .topCenter || position == .topRight
    }
    
    private func isLeftPosition(_ position: FloatingButtonPosition) -> Bool {
        return position == .bottomLeft || position == .topLeft
    }
    
    private func isRightPosition(_ position: FloatingButtonPosition) -> Bool {
        return position == .bottomRight || position == .topRight
    }
}

public enum FloatingButtonPosition {
    case bottomLeft
    case bottomCenter
    case bottomRight
    
    case topLeft
    case topCenter
    case topRight
}

// MARK: Implementation example
struct FloatingButtonExample: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                Text(sampleText)
                    .padding()
            }
            
            FloatingButton(image: Image(systemName: "plus"),
                           backgroundColor: .blue.opacity(0.8),
                           foregroundColor: .white,
                           size: 30,
                           position: .bottomRight, 
                           clipShape: Circle()) {
                print("Button example action!!")
            }
        }
    }
}

#Preview {
    FloatingButtonExample()
}

let sampleText = """
Lorem ipsum dolor sit amet. Cum enim sapiente ut officiis perspiciatis qui tenetur placeat? Et similique corporis ut quia nobis ex error aperiam ut amet deleniti et dolorum inventore non quam eaque. Aut consequatur adipisci aut placeat vitae et voluptate laboriosam aut harum deleniti ut quia enim id recusandae dolores. Hic dolorem sunt aut vitae consequatur et numquam sint. Vel expedita ipsa hic repudiandae eveniet aut fugit fugiat.
Qui neque sequi et consequatur fugit eos impedit libero. Eos velit maiores aut reprehenderit maxime qui dolores dicta est quasi illo et aspernatur impedit. A minus corporis sint sapiente non nemo dolorem ut officia ut odio natus et nobis dignissimos eos dicta asperiores. Et incidunt esse eos nisi repudiandae aut commodi optio sit ipsam distinctio et incidunt voluptatem rem dolorem molestiae qui reiciendis ullam. Aut galisum incidunt et maxime commodi qui odit dolorum et vitae aspernatur. Vel possimus aspernatur cum corporis dolorum consequuntur modi cum alias voluptates ea quia quia. Eum quam consequatur in galisum enim et esse error nam magni quas. Ut consequuntur similique est fugiat sapiente hic eveniet vero quo perspiciatis dolorum. Et alias pariatur ea dolor corrupti quo iusto vitae ut voluptas vitae ut reiciendis recusandae sed similique illo.
Nam maxime impedit et dolorem voluptas qui neque iure. Hic amet tenetur ad voluptatum fugit et voluptatem nesciunt. In nesciunt illo qui voluptas molestias qui dolorem voluptas sit iusto consequatur a magni maxime. Quo galisum accusamus id omnis maxime qui labore molestiae. Recusandae molestias et sequi iure a reiciendis neque sit facilis fuga sit fuga omnis qui reiciendis totam rem omnis eius? Sed molestias nulla qui reprehenderit quibusdam est ipsam iusto est iste enim et nihil maxime ea atque vitae! Et recusandae quos eum nihil ducimus est dolorem quaerat qui rerum iusto.
"""
