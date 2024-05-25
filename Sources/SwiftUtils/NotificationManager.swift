//
//  NotificationManager.swift
//
//
//  Created by Raul on 25/5/24.
//

import Foundation
import UserNotifications

struct NotificationManager{
    /**
       Schedules a local notification with the specified date, title, and message.
       - Parameters:
          - date: A `Date` object representing the date and time when the notification should be triggered.
          - title: A string representing the title of the notification.
          - message: A string representing the body of the notification.

       - Note: This function logs an error message if there is an issue scheduling the notification.
    */
    func scheduleNotification(date: Date, title: String, message: String) {
        // Creates the content of the notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message

        // Set the notification trigger to the specified date
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute],
                                                     from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // Creates the notification request
        let request = UNNotificationRequest(identifier: date.description, content: content, trigger: trigger)

        // Schedule notification
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error in scheduling notification: \(error.localizedDescription)")
            }
        }
    }

    /**
       Removes a scheduled notification for the specified date.
       - Parameters:
          - date: A `Date` object representing the date and time of the notification to be removed.

       - Note: This function logs the deletion action and ensures the notification is removed from pending requests.
    */
    func removeNotification(date: Date) {
        let identifier = date.description
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

        center.getPendingNotificationRequests { (requests) in
            let matchingRequests = requests.filter { $0.identifier == identifier }
            center.removePendingNotificationRequests(withIdentifiers: matchingRequests.map { $0.identifier })
        }
    }

    /**
       Lists all scheduled notifications with their details including the date, title, and body.
       - Note: This function retrieves all pending notification requests from `UNUserNotificationCenter` and logs the details of each notification.
    */
    func listAllNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print("Scheduled notifications:")

            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    let date = trigger.nextTriggerDate()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let dateString = dateFormatter.string(from: date ?? Date())
                    print("Date and hour: \(dateString)")
                }
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
                print("---")
            }
        }
    }

    /**
       Checks if a notification is scheduled for a specific date.
       - Parameters:
          - date: A `Date` object representing the date and time to check for a scheduled notification.

       - Returns: A boolean indicating whether a notification is scheduled for the specified date.

       - Note: This function synchronously checks the pending notifications, which may block the main thread.
    */
    func checkIfNotificationsExists(date: Date) -> Bool {
        let center = UNUserNotificationCenter.current()
        let semaphore = DispatchSemaphore(value: 0)
        var notificationScheduled = false

        center.getPendingNotificationRequests { requests in
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            let notificationDate = Calendar.current.date(from: dateComponents)

            notificationScheduled = requests.contains { request in
                guard let trigger = request.trigger as? UNCalendarNotificationTrigger else {
                    return false
                }
                return trigger.nextTriggerDate() == notificationDate
            }

            semaphore.signal()
        }

        semaphore.wait()
        return notificationScheduled
    }

    /**
       Cancels all scheduled local notifications.
       - Note: This function removes all pending notification requests from `UNUserNotificationCenter`.
    */
    func cancelAllLocalNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
