//
//  WeeklyNotificationSchedule.swift
//
//
//  Created by Raul on 28/9/26.
//

import Foundation
import UserNotifications

/// A set of local notifications delivered at the same times on selected weekdays.
public struct WeeklyNotificationSchedule: Sendable, Equatable {
    /// Per-schedule cap. The app-wide pending request budget is checked separately.
    public static let maximumRequests = 60

    /// Local clock times as minutes after midnight (0...1439).
    public let minutesOfDay: [Int]
    /// Calendar weekday numbers (1 = Sunday, 7 = Saturday).
    public let weekdays: Set<Int>

    public init(minutesOfDay: [Int], weekdays: Set<Int>) {
        self.minutesOfDay = Array(Set(minutesOfDay)).sorted()
        self.weekdays = weekdays
    }

    public init(everyHours intervalHours: Int, from startMinutes: Int, through endMinutes: Int,
                weekdays: Set<Int>) {
        guard (1 ... 24).contains(intervalHours),
              (0 ... 1439).contains(startMinutes),
              (0 ... 1439).contains(endMinutes),
              startMinutes <= endMinutes else {
            self.init(minutesOfDay: [], weekdays: weekdays)
            return
        }
        self.init(minutesOfDay: Array(stride(from: startMinutes, through: endMinutes,
                                              by: intervalHours * 60)), weekdays: weekdays)
    }

    public var requestCount: Int {
        minutesOfDay.count * (weekdays.count == 7 ? 1 : weekdays.count)
    }

    public var isValid: Bool {
        !minutesOfDay.isEmpty
            && minutesOfDay.allSatisfy { (0 ... 1439).contains($0) }
            && !weekdays.isEmpty
            && weekdays.allSatisfy { (1 ... 7).contains($0) }
            && requestCount <= Self.maximumRequests
    }
}

public enum WeeklyNotificationError: Error, Equatable {
    case invalidSchedule
    case permissionDenied
    case capacityExceeded
    case schedulingFailed
}

extension NotificationManager {
    /// Replaces only notifications whose identifiers begin with `identifierPrefix`.
    /// Give each feature its own prefix. Pass `nil` to remove its requests without
    /// requesting notification permission.
    /// Throws `capacityExceeded` without changing pending requests if the replacement
    /// would exceed 64 requests across the app. Weekly replacements share a serial queue;
    /// callers using other scheduling APIs must coordinate their own mutations.
    public func replaceWeeklyNotifications(
        schedule: WeeklyNotificationSchedule?,
        identifierPrefix: String,
        title: String,
        body: String
    ) async throws {
        guard !identifierPrefix.isEmpty, schedule?.isValid ?? true else {
            throw WeeklyNotificationError.invalidSchedule
        }

        let center = UNUserNotificationCenter.current()
        if schedule != nil {
            let settings = await center.notificationSettings()
            switch settings.authorizationStatus {
            case .notDetermined:
                guard try await center.requestAuthorization(options: [.alert, .sound]) else {
                    throw WeeklyNotificationError.permissionDenied
                }
            case .authorized, .provisional:
                break
            #if os(iOS)
            case .ephemeral:
                break
            #endif
            default:
                throw WeeklyNotificationError.permissionDenied
            }
        }

        let newRequests = schedule.map {
            Self.weeklyRequests(for: $0, identifierPrefix: identifierPrefix, title: title, body: body)
        } ?? []
        try await WeeklyNotificationScheduler.shared.enqueueReplacement(
            requests: newRequests, identifierPrefix: identifierPrefix
        ).value
    }

    private static func weeklyRequests(
        for schedule: WeeklyNotificationSchedule,
        identifierPrefix: String,
        title: String,
        body: String
    ) -> [UNNotificationRequest] {
        let days: [Int?] = schedule.weekdays.count == 7
            ? [nil] : schedule.weekdays.sorted().map(Optional.some)

        return days.flatMap { weekday in
            schedule.minutesOfDay.map { minutes in
                var components = DateComponents()
                components.weekday = weekday
                components.hour = minutes / 60
                components.minute = minutes % 60

                let content = UNMutableNotificationContent()
                content.title = title
                content.body = body
                content.sound = .default

                let dayKey = weekday.map(String.init) ?? "daily"
                let identifier = "\(identifierPrefix)\(dayKey).\(minutes)"
                let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
                return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            }
        }
    }
}

/// Serializes weekly replacements across prefixes and manager instances, including rollback.
/// Other code scheduling notifications directly must also respect the shared system budget.
@MainActor
final class WeeklyNotificationScheduler {
    static let shared = WeeklyNotificationScheduler(
        pendingRequests: { await UNUserNotificationCenter.current().pendingNotificationRequests() },
        add: { try await UNUserNotificationCenter.current().add($0) },
        remove: { UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: $0) }
    )

    private let pendingRequests: @MainActor () async -> [UNNotificationRequest]
    private let add: @MainActor (UNNotificationRequest) async throws -> Void
    private let remove: @MainActor ([String]) -> Void
    private var tail: Task<Void, Never>?

    init(
        pendingRequests: @escaping @MainActor () async -> [UNNotificationRequest],
        add: @escaping @MainActor (UNNotificationRequest) async throws -> Void,
        remove: @escaping @MainActor ([String]) -> Void
    ) {
        self.pendingRequests = pendingRequests
        self.add = add
        self.remove = remove
    }

    // Enqueue synchronously so the snapshot and all mutations run in submission order.
    // Once submitted, a replacement completes even if its caller is cancelled.
    func enqueueReplacement(
        requests: [UNNotificationRequest], identifierPrefix: String
    ) -> Task<Void, Error> {
        let predecessor = tail
        let operation = Task { @MainActor in
            await predecessor?.value
            let pending = await pendingRequests()
            let previous = pending.filter { $0.identifier.hasPrefix(identifierPrefix) }
            let otherCount = pending.count - previous.count
            // Removal must remain possible even if the existing queue exceeds the budget.
            guard requests.isEmpty || otherCount + requests.count <= 64 else {
                throw WeeklyNotificationError.capacityExceeded
            }

            remove(previous.map(\.identifier))
            do {
                for request in requests {
                    try await add(request)
                }
            } catch {
                remove(requests.map(\.identifier))
                for request in previous {
                    try? await add(request)
                }
                throw WeeklyNotificationError.schedulingFailed
            }
        }
        tail = Task { _ = await operation.result }
        return operation
    }
}
