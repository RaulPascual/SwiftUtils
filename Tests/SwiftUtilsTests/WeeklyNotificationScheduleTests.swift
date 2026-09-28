//
//  WeeklyNotificationScheduleTests.swift
//
//
//  Created by Raul on 28/9/26.
//

import XCTest
import UserNotifications
@testable import SwiftUtilities

final class WeeklyNotificationScheduleTests: XCTestCase {
    func testIntervalIncludesBothEndpointsWhenTheyMatchTheStep() {
        let schedule = WeeklyNotificationSchedule(everyHours: 2, from: 9 * 60,
                                                   through: 13 * 60, weekdays: [2, 4])

        XCTAssertEqual(schedule.minutesOfDay, [9 * 60, 11 * 60, 13 * 60])
        XCTAssertEqual(schedule.requestCount, 6)
        XCTAssertTrue(schedule.isValid)
    }

    func testAllWeekdaysNeedOneRepeatingRequestPerTime() {
        let schedule = WeeklyNotificationSchedule(minutesOfDay: [12 * 60, 9 * 60, 12 * 60],
                                                   weekdays: Set(1 ... 7))

        XCTAssertEqual(schedule.minutesOfDay, [9 * 60, 12 * 60])
        XCTAssertEqual(schedule.requestCount, 2)
        XCTAssertTrue(schedule.isValid)
    }

    func testInvalidInputsCannotBeScheduled() {
        XCTAssertFalse(WeeklyNotificationSchedule(everyHours: 0, from: 9 * 60,
                                                    through: 18 * 60, weekdays: [2]).isValid)
        XCTAssertFalse(WeeklyNotificationSchedule(minutesOfDay: [9 * 60], weekdays: []).isValid)
        XCTAssertFalse(WeeklyNotificationSchedule(minutesOfDay: [1440], weekdays: [2]).isValid)
        XCTAssertFalse(WeeklyNotificationSchedule(minutesOfDay: [9 * 60], weekdays: [8]).isValid)
    }

    func testPerScheduleLimit() {
        XCTAssertTrue(WeeklyNotificationSchedule(minutesOfDay: Array(0 ..< 60), weekdays: [2]).isValid)
        XCTAssertFalse(WeeklyNotificationSchedule(minutesOfDay: Array(0 ..< 61), weekdays: [2]).isValid)
    }

    @MainActor
    func testCapacityFailurePreservesExistingRequests() async throws {
        let store = NotificationStore()
        store.requests = (0 ..< 5).map { store.request("other.\($0)") } + [store.request("weekly.old")]
        let scheduler = store.scheduler()
        do {
            try await scheduler.enqueueReplacement(
                requests: (0 ..< 60).map { store.request("weekly.\($0)") }, identifierPrefix: "weekly."
            ).value
            XCTFail("Expected the shared budget to reject 65 requests")
        } catch {
            XCTAssertEqual(error as? WeeklyNotificationError, .capacityExceeded)
        }
        XCTAssertEqual(store.requests.count, 6)
        XCTAssertTrue(store.requests.contains { $0.identifier == "weekly.old" })
        XCTAssertEqual(store.removalCount, 0)
    }

    @MainActor
    func testReplacementDiscountsPreviousRequestsAtCapacity() async throws {
        let store = NotificationStore()
        store.requests = (0 ..< 4).map { store.request("other.\($0)") }
            + (0 ..< 60).map { store.request("weekly.old.\($0)") }
        try await store.scheduler().enqueueReplacement(
            requests: (0 ..< 60).map { store.request("weekly.new.\($0)") }, identifierPrefix: "weekly."
        ).value
        XCTAssertEqual(store.requests.count, 64)
        XCTAssertFalse(store.requests.contains { $0.identifier.hasPrefix("weekly.old.") })
    }

    @MainActor
    func testConcurrentReplacementsKeepOnlyLatestSchedule() async throws {
        let store = NotificationStore()
        let scheduler = store.scheduler()
        let first = scheduler.enqueueReplacement(
            requests: [store.request("weekly.first.1"), store.request("weekly.first.2")],
            identifierPrefix: "weekly."
        )
        let second = scheduler.enqueueReplacement(
            requests: [store.request("weekly.second")], identifierPrefix: "weekly."
        )
        try await first.value
        try await second.value
        XCTAssertEqual(store.requests.map(\.identifier), ["weekly.second"])
    }

    @MainActor
    func testQueuedRemovalDoesNotLeaveRequestsFromEarlierReplacement() async throws {
        let store = NotificationStore()
        let scheduler = store.scheduler()
        let replacement = scheduler.enqueueReplacement(
            requests: [store.request("weekly.1"), store.request("weekly.2")], identifierPrefix: "weekly."
        )
        let removal = scheduler.enqueueReplacement(requests: [], identifierPrefix: "weekly.")
        try await replacement.value
        try await removal.value
        XCTAssertTrue(store.requests.isEmpty)
    }

    @MainActor
    func testConcurrentPrefixesShareCapacityAndQueueContinuesAfterFailure() async throws {
        let store = NotificationStore()
        let scheduler = store.scheduler()
        let first = scheduler.enqueueReplacement(
            requests: (0 ..< 40).map { store.request("first.\($0)") }, identifierPrefix: "first."
        )
        let second = scheduler.enqueueReplacement(
            requests: (0 ..< 40).map { store.request("second.\($0)") }, identifierPrefix: "second."
        )
        let removal = scheduler.enqueueReplacement(requests: [], identifierPrefix: "first.")
        try await first.value
        do {
            try await second.value
            XCTFail("Expected the second schedule to exceed the shared budget")
        } catch {
            XCTAssertEqual(error as? WeeklyNotificationError, .capacityExceeded)
        }
        try await removal.value
        XCTAssertTrue(store.requests.isEmpty)
    }
}

@MainActor
private final class NotificationStore {
    var requests: [UNNotificationRequest] = []
    var removalCount = 0

    func request(_ identifier: String) -> UNNotificationRequest {
        UNNotificationRequest(identifier: identifier, content: UNMutableNotificationContent(), trigger: nil)
    }

    func scheduler() -> WeeklyNotificationScheduler {
        WeeklyNotificationScheduler(
            pendingRequests: { self.requests },
            add: { request in
                // Allow another operation to run while an add is suspended.
                await Task.yield()
                self.requests.removeAll { $0.identifier == request.identifier }
                self.requests.append(request)
            },
            remove: { identifiers in
                self.removalCount += 1
                self.requests.removeAll { identifiers.contains($0.identifier) }
            }
        )
    }
}
