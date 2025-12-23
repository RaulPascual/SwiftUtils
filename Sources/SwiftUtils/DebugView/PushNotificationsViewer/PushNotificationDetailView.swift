//
//  PushNotificationDetailView.swift
//
//
//  Created by Raul on 20/12/24.
//

import SwiftUI

struct PushNotificationDetailView: View {
    let notification: PushNotificationStore.PushNotification

    var body: some View {
        List {
            contentSection
            metadataSection
            payloadSection
        }
        .navigationTitle("Notification Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Content Section

    private var contentSection: some View {
        Section("Content") {
            if let title = notification.title {
                LabeledContent("Title", value: title)
            }

            if let subtitle = notification.subtitle {
                LabeledContent("Subtitle", value: subtitle)
            }

            if let body = notification.body {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Body")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(body)
                        .textSelection(.enabled)
                }
            }

            if notification.title == nil && notification.subtitle == nil && notification.body == nil {
                Text("No content (silent push)")
                    .foregroundStyle(.secondary)
                    .italic()
            }
        }
    }

    // MARK: - Metadata Section

    private var metadataSection: some View {
        Section("Metadata") {
            LabeledContent("Received") {
                Text(notification.date, format: .dateTime)
            }

            LabeledContent("Source") {
                HStack {
                    if notification.isFromBackground {
                        Image(systemName: "moon.fill")
                            .foregroundStyle(.purple)
                        Text("Background")
                    } else {
                        Image(systemName: "sun.max.fill")
                            .foregroundStyle(.orange)
                        Text("Foreground")
                    }
                }
            }

            if let badge = notification.badge {
                LabeledContent("Badge", value: "\(badge)")
            }

            if let category = notification.category {
                LabeledContent("Category", value: category)
            }

            if let threadId = notification.threadId {
                LabeledContent("Thread ID", value: threadId)
            }

            if let interruptionLevel = notification.interruptionLevel {
                LabeledContent("Interruption Level") {
                    interruptionLevelBadge(interruptionLevel)
                }
            }
        }
    }

    // MARK: - Payload Section

    private var payloadSection: some View {
        Section("Raw Payload (userInfo)") {
            if notification.userInfo.isEmpty {
                Text("No custom data")
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(notification.userInfo.keys.sorted(), id: \.self) { key in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(key)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)

                        Text(formatValue(notification.userInfo[key] ?? ""))
                            .font(.system(.caption, design: .monospaced))
                            .textSelection(.enabled)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
    }

    // MARK: - Helpers

    private func interruptionLevelBadge(_ level: String) -> some View {
        let color: Color = switch level {
        case "passive": .gray
        case "active": .blue
        case "time-sensitive": .orange
        case "critical": .red
        default: .secondary
        }

        return Text(level)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
            .foregroundStyle(color)
    }

    private func formatValue(_ value: String) -> String {
        // Try to pretty-print JSON
        if let data = value.data(using: .utf8),
           let json = try? JSONSerialization.jsonObject(with: data),
           let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }
        return value
    }
}

#Preview {
    NavigationStack {
        PushNotificationDetailView(
            notification: PushNotificationStore.PushNotification(
                date: Date(),
                title: "New Message",
                subtitle: "From John",
                body: "Hey, how are you doing today?",
                badge: 5,
                category: "MESSAGE_CATEGORY",
                threadId: "conversation-123",
                userInfo: [
                    "aps": "{\"alert\":{\"title\":\"New Message\"},\"badge\":5}",
                    "messageId": "\"abc123\"",
                    "senderId": "\"user-456\""
                ],
                interruptionLevel: "time-sensitive",
                isFromBackground: false
            )
        )
    }
}
