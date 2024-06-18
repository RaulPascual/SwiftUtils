//
//  OnboardingView.swift
//
//
//  Created by Raul on 27/5/24.
//

import SwiftUI
/**
 A view representing an onboarding screen, displaying a series of onboarding views with navigation.

 - Parameters:
    - primaryBackgroundColor: The primary background color of the onboarding view.
    - secondaryBackgroundColor: An optional secondary background color. Default is nil.
    - buttonImage: The image for the navigation button. Default is a system image "arrow.right.circle.fill".
    - onboardViews: An array of `OnBoardView` objects representing the individual onboarding views.

 - Note: The `onboardingViewed` property is used to track if the onboarding has been viewed, stored in `AppStorage`.
 */
public struct OnboardingView: View {
    @AppStorage("onboardingViewed") var onboardingViewed: Bool?
    let primaryBackgroundColor: Color
    let secondaryBackgroundColor: Color? = nil
    let buttonImage: Image = Image(systemName: "arrow.right.circle.fill")
    let onboardViews: [OnBoardView]
    
    public init(onboardingViewed: Bool? = nil, 
                primaryBackgroundColor: Color,
                onboardViews: [OnBoardView]) {
        self._onboardingViewed = AppStorage("onboardingViewed")
        self.primaryBackgroundColor = primaryBackgroundColor
        self.onboardViews = onboardViews
    }
    
    public var body: some View {
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

/**
 A view representing a single onboarding screen.

 - Parameters:
    - id: A unique identifier for the onboarding view.
    - image: The image to be displayed in the onboarding view.
    - title: The title text of the onboarding view.
    - description: An optional description text for the onboarding view. Default is nil.
    - titleForegroundColor: An optional color for the title text. Default is nil.
    - descriptionForegroundColor: An optional color for the description text. Default is nil.
    - comingSoon: An optional boolean indicating if the feature is coming soon. Default is false.
 */
public struct OnBoardView: View, Identifiable {
    public var id: UUID
    var image: Image
    var title: String
    var description: String?
    var titleForegrounColor: Color?
    var descriptionForegrounColor: Color?
    var comingSoon: Bool? = false
    
    public init(id: UUID, image: Image, title: String, description: String? = nil, 
                titleForegrounColor: Color? = nil, descriptionForegrounColor: Color? = nil,
                comingSoon: Bool? = nil) {
        self.id = id
        self.image = image
        self.title = title
        self.description = description
        self.titleForegrounColor = titleForegrounColor
        self.descriptionForegrounColor = descriptionForegrounColor
        self.comingSoon = comingSoon
    }
    
    public var body: some View {
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
