//
//  PushNotificationStore.swift
//
//
//  Created by Raul on 20/12/24.
//

import Foundation
import UserNotifications

@MainActor
public final class PushNotificationStore: ObservableObject {
    public static let shared = PushNotificationStore()

    @Published public var notifications: [PushNotification] = []

    private init() {}

    public struct PushNotification: Identifiable, Sendable {
        public let id = UUID()
        public let date: Date
        public let title: String?
        public let subtitle: String?
        public let body: String?
        public let badge: Int?
        public let category: String?
        public let threadId: String?
        public let userInfo: [String: String]
        public let interruptionLevel: String?
        public let isFromBackground: Bool

        public init(
            date: Date = Date(),
            title: String? = nil,
            subtitle: String? = nil,
            body: String? = nil,
            badge: Int? = nil,
            category: String? = nil,
            threadId: String? = nil,
            userInfo: [String: String] = [:],
            interruptionLevel: String? = nil,
            isFromBackground: Bool = false
        ) {
            self.date = date
            self.title = title
            self.subtitle = subtitle
            self.body = body
            self.badge = badge
            self.category = category
            self.threadId = threadId
            self.userInfo = userInfo
            self.interruptionLevel = interruptionLevel
            self.isFromBackground = isFromBackground
        }
    }

    /// Adds a push notification to the history.
    public func add(_ notification: PushNotification) {
        notifications.append(notification)
    }

    /// Convenience method to add a notification from UNNotification.
    /// Call this from your UNUserNotificationCenterDelegate methods.
    ///
    /// Example usage in AppDelegate:
    /// ```swift
    /// func userNotificationCenter(_ center: UNUserNotificationCenter,
    ///                             willPresent notification: UNNotification,
    ///                             withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    ///     #if DEBUG
    ///     Task { @MainActor in
    ///         PushNotificationStore.shared.add(from: notification, isFromBackground: false)
    ///     }
    ///     #endif
    ///     completionHandler([.banner, .sound, .badge])
    /// }
    /// ```
    public func add(from notification: UNNotification, isFromBackground: Bool) {
        let content = notification.request.content

        let interruptionLevelString = describeInterruptionLevel(content.interruptionLevel)

        let userInfoStrings = convertUserInfoToStrings(content.userInfo)

        let pushNotification = PushNotification(
            date: notification.date,
            title: content.title.isEmpty ? nil : content.title,
            subtitle: content.subtitle.isEmpty ? nil : content.subtitle,
            body: content.body.isEmpty ? nil : content.body,
            badge: content.badge?.intValue,
            category: content.categoryIdentifier.isEmpty ? nil : content.categoryIdentifier,
            threadId: content.threadIdentifier.isEmpty ? nil : content.threadIdentifier,
            userInfo: userInfoStrings,
            interruptionLevel: interruptionLevelString,
            isFromBackground: isFromBackground
        )

        add(pushNotification)
    }

    /// Convenience method to add a notification from a raw userInfo dictionary.
    /// Call this from `application(_:didReceiveRemoteNotification:fetchCompletionHandler:)` for silent push.
    ///
    /// Example usage:
    /// ```swift
    /// func application(_ application: UIApplication,
    ///                  didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    ///                  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    ///     #if DEBUG
    ///     Task { @MainActor in
    ///         PushNotificationStore.shared.add(fromUserInfo: userInfo, isFromBackground: true)
    ///     }
    ///     #endif
    ///     completionHandler(.newData)
    /// }
    /// ```
    public func add(fromUserInfo userInfo: [AnyHashable: Any], isFromBackground: Bool) {
        var title: String? = nil
        var subtitle: String? = nil
        var body: String? = nil
        var badge: Int? = nil
        var category: String? = nil
        var threadId: String? = nil

        if let aps = userInfo["aps"] as? [String: Any] {
            if let alert = aps["alert"] as? [String: Any] {
                title = alert["title"] as? String
                subtitle = alert["subtitle"] as? String
                body = alert["body"] as? String
            } else if let alertString = aps["alert"] as? String {
                body = alertString
            }

            badge = aps["badge"] as? Int
            category = aps["category"] as? String
            threadId = aps["thread-id"] as? String
        }

        let userInfoStrings = convertUserInfoToStrings(userInfo)

        let pushNotification = PushNotification(
            date: Date(),
            title: title,
            subtitle: subtitle,
            body: body,
            badge: badge,
            category: category,
            threadId: threadId,
            userInfo: userInfoStrings,
            interruptionLevel: nil,
            isFromBackground: isFromBackground
        )

        add(pushNotification)
    }

    /// Clears all stored notifications.
    public func clear() {
        notifications.removeAll()
    }

    // MARK: - Private Helpers

    private func convertUserInfoToStrings(_ userInfo: [AnyHashable: Any]) -> [String: String] {
        var result: [String: String] = [:]
        for (key, value) in userInfo {
            let keyString = String(describing: key)
            if let jsonData = try? JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                result[keyString] = jsonString
            } else {
                result[keyString] = String(describing: value)
            }
        }
        return result
    }

    private func describeInterruptionLevel(_ level: UNNotificationInterruptionLevel) -> String {
        switch level {
        case .passive:
            return "passive"
        case .active:
            return "active"
        case .timeSensitive:
            return "time-sensitive"
        case .critical:
            return "critical"
        @unknown default:
            return "unknown"
        }
    }
}
