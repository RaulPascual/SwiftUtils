//
//  PushNotificationListView.swift
//
//
//  Created by Raul on 20/12/24.
//

import SwiftUI

struct PushNotificationListView: View {
    @StateObject private var store = PushNotificationStore.shared
    @State private var searchText = ""

    private var filteredNotifications: [PushNotificationStore.PushNotification] {
        let sorted = store.notifications.sorted { $0.date > $1.date }

        if searchText.isEmpty {
            return sorted
        }

        return sorted.filter { notification in
            let searchLower = searchText.lowercased()
            return (notification.title?.lowercased().contains(searchLower) ?? false) ||
                   (notification.body?.lowercased().contains(searchLower) ?? false) ||
                   (notification.category?.lowercased().contains(searchLower) ?? false) ||
                   notification.userInfo.values.contains { $0.lowercased().contains(searchLower) }
        }
    }

    var body: some View {
        VStack {
            if store.notifications.isEmpty {
                emptyStateView
            } else {
                notificationsList
            }
        }
        .navigationTitle("Push Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !store.notifications.isEmpty {
                    Button(role: .destructive) {
                        store.clear()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.gray)
                .font(.system(size: 60))

            Text("No push notifications received yet")
                .foregroundStyle(.secondary)

            Text("Notifications will appear here when your app receives them.")
                .font(.footnote)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var notificationsList: some View {
        List {
            ForEach(filteredNotifications) { notification in
                NavigationLink {
                    PushNotificationDetailView(notification: notification)
                } label: {
                    notificationRow(notification)
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search notifications")
    }

    private func notificationRow(_ notification: PushNotificationStore.PushNotification) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                if notification.isFromBackground {
                    Image(systemName: "moon.fill")
                        .font(.caption)
                        .foregroundStyle(.purple)
                } else {
                    Image(systemName: "sun.max.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }

                Text(notification.title ?? "No title")
                    .font(.headline)
                    .lineLimit(1)

                Spacer()

                if let badge = notification.badge {
                    Text("\(badge)")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.red, in: Capsule())
                }
            }

            if let body = notification.body {
                Text(body)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack {
                Text(notification.date, format: .dateTime.month().day().hour().minute().second())
                    .font(.caption)
                    .foregroundStyle(.tertiary)

                Spacer()

                if let category = notification.category {
                    Text(category)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.blue.opacity(0.1), in: RoundedRectangle(cornerRadius: 4))
                        .foregroundStyle(.blue)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        PushNotificationListView()
    }
}
