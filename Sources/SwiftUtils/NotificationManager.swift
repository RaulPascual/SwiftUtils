//
//  NotificationManager.swift
//
//
//  Created by Raul on 25/5/24.
//

import Foundation
import UserNotifications

public protocol NotificationScheduling {
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?)
}

extension UNUserNotificationCenter: NotificationScheduling {}

public struct NotificationManager {
    private let notificationCenter: NotificationScheduling

    public init(notificationCenter: NotificationScheduling = UNUserNotificationCenter.current()) {
        self.notificationCenter = notificationCenter
    }

    /**
       Schedules a local notification with the specified date, title, and message.
       - Parameters:
          - date: A `Date` object representing the date and time when the notification should be triggered.
          - title: A string representing the title of the notification.
          - message: A string representing the body of the notification.

       - Note: This function logs an error message if there is an issue scheduling the notification.
    */
    public func scheduleNotification(date: Date, title: String, message: String) {
        // Creates the content of the notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message

        // Set the notification trigger to the specified date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // Creates the notification request
        let request = UNNotificationRequest(identifier: date.description, content: content, trigger: trigger)

        // Schedule notification
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error in scheduling notification: \(error.localizedDescription)")
            }
        }
    }
}
