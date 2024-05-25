//import XCTest
//@testable import SwiftUtils
//
//final class NotificationManagerTests: XCTestCase {
//    func testScheduleNotification() {
//            // Arrange
//            let mockNotificationCenter = MockNotificationCenter()
//            let notificationManager = NotificationManager(notificationCenter: mockNotificationCenter)
//            let date = Date()
//            let title = "Test Title"
//            let message = "Test Message"
//            
//            // Act
//            notificationManager.scheduleNotification(date: date, title: title, message: message)
//            
//            // Assert
//            XCTAssertTrue(mockNotificationCenter.didAddRequest, "The add(_:withCompletionHandler:) method should be called")
//            XCTAssertEqual(mockNotificationCenter.addedRequest?.content.title, title, "The notification title should be set correctly")
//            XCTAssertEqual(mockNotificationCenter.addedRequest?.content.body, message, "The notification message should be set correctly")
//            
//            // Optionally check the trigger date components
//            let calendar = Calendar.current
//            let expectedDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//            let trigger = mockNotificationCenter.addedRequest?.trigger as? UNCalendarNotificationTrigger
//            XCTAssertEqual(trigger?.dateComponents, expectedDateComponents, "The notification trigger date components should be set correctly")
//        }
//}
//
//
//class MockNotificationCenter: NotificationScheduling {
//    var didAddRequest = false
//    var addedRequest: UNNotificationRequest?
//    var completionHandler: ((Error?) -> Void)?
//
//    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
//        didAddRequest = true
//        addedRequest = request
//        self.completionHandler = completionHandler
//    }
//}
