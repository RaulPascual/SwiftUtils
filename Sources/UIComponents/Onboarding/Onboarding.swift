//
//  OnboardingView.swift
//
//
//  Created by Raul on 27/5/24.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("onboardingViewed") var onboardingViewed: Bool?
    let primaryBackgroundColor: Color
    let secondaryBackgroundColor: Color? = nil
    let buttonImage: Image = Image(systemName: "arrow.right.circle.fill")
    let onboardViews: [OnBoardView]
    
    var body: some View {
        VStack {
            TabView {
                ForEach(onboardViews) { view in
                    view
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            
            HStack {
                Spacer()
                Button {
                    self.onboardingViewed = true
                } label: {
                    buttonImage
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(.init(top: 20, leading: 50, bottom: 20, trailing: 30))
                .customAccessibility(label: "OnBoardingAccessibilityNextPage",
                                     traits: .isButton)
            }
        }
        .background(LinearGradient(gradient: Gradient(colors: [primaryBackgroundColor, secondaryBackgroundColor ?? .white]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing))
    }
}

struct OnBoardView: View, Identifiable {
    var id: UUID
    var image: Image
    var title: String
    var description: String?
    var titleForegrounColor: Color?
    var descriptionForegrounColor: Color?
    var comingSoon: Bool? = false
    
    var body: some View {
        VStack(spacing: 30) {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .accessibilityHidden(true)
            Text(title)
                .foregroundStyle(titleForegrounColor ?? .black)
                .font(.title)
                .bold()
                .customAccessibility(label: title)
            if let description {
                Text(description)
                    .foregroundStyle(descriptionForegrounColor ?? .secondary)
                    .multilineTextAlignment(.center)
                    .bold()
                    .customAccessibility(label: description)
            }
            
            if comingSoon ?? false {
                Text("OnBoardingComingSoon")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    onboardingTestView
}

let onboardingTestView = OnboardingView(primaryBackgroundColor: .blue,
                                        onboardViews: [OnBoardView(id: UUID(),
                                                                   image: Image(systemName: "figure.soccer"),
                                                                   title: "Title 1",
                                                                   description: "Description of first view"),
                                                       OnBoardView(id: UUID(),
                                                                   image: Image(systemName: "heart"),
                                                                   title: "Title 2",
                                                                   description: "Description of second view")])
