//
//  SwiftUIView.swift
//
//
//  Created by Raul on 28/5/24.
//

import SwiftUI

/**
 A view prompting the user to update the app, with customizable content and appearance.

 - Parameters:
    - title: The title text of the update prompt.
    - description: An optional description text for the update prompt. Default is nil.
    - buttonText: The text displayed on the update button.
    - backgroundColor: The background color of the view. Default is white.
    - buttonForegroundColor: The foreground color of the update button. Default is white.
    - buttonBackgroundColor: The background color of the update button. Default is blue with 0.8 opacity.
    - image: The image displayed in the update prompt. Default is a system image "icloud.and.arrow.down".
    - appStoreURL: An optional URL to the App Store for updating the app.

 - Note: The view includes a button that, when pressed, opens the specified `appStoreURL` if provided.
 */
struct UpdateAppView: View {
    var title: LocalizedStringKey
    var description: LocalizedStringKey? = nil
    var buttonText: LocalizedStringKey
    var backgroundColor: Color = .white
    var buttonForegroundColor: Color = .white
    var buttonBackgroundColor: Color = .blue.opacity(0.8)
    var image: Image = Image(systemName: "icloud.and.arrow.down")
    var appStoreURL: URL?
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .padding()
            
            if let description {
                Text(description)
                    .font(.title3)
                    .padding()
            }
            
            if let appStoreURL {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 50, maxHeight: 50)
                    .padding()
                    .foregroundColor(Color.green)
                    .onTapGesture {
                        UIApplication.shared.open(appStoreURL)
                    }
                
                Button {
                    UIApplication.shared.open(appStoreURL)
                } label: {
                    Text(buttonText)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        .foregroundStyle(buttonForegroundColor)
                        .background(buttonBackgroundColor
                            .clipShape(RoundedRectangle(cornerRadius: 10)))
                        .padding([.leading, .trailing], 20)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundColor)
    }
}

#Preview {
    exampleUpdateView()
}

struct exampleUpdateView: View {
    var body: some View {
        VStack {
            Text("Some text")
        }
        .customSheet(isPresented: .constant(true),
                     presentationDetents: [.medium]) {
            UpdateAppView(title: LocalizedStringKey("UpdateTitle"),
                          description: LocalizedStringKey("UpdateDescription"),
                          buttonText: LocalizedStringKey("UpdateButton"),
                          backgroundColor: .blue.opacity(0.2),
                          buttonForegroundColor: .white,
                          buttonBackgroundColor: .blue.opacity(0.6),
                          image: Image(systemName: "cloud.fill"),
                          appStoreURL: URL(string: "www.example.com"))
        }
    }
}
