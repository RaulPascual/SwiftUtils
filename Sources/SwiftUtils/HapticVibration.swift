//
//  HapticVibration.swift
//
//
//  Created by Raul on 28/5/24.
//

import UIKit

// MARK: - Haptic vibrations
/**
 Triggers a haptic vibration using the specified feedback style.

 - Parameters:
    - style: The style of the haptic feedback, specified as a `UIImpactFeedbackGenerator.FeedbackStyle`.

 - Note: This function uses `UIImpactFeedbackGenerator` to generate haptic feedback.
 */
@MainActor func hapticVibration(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
    feedbackGenerator.impactOccurred()
}
