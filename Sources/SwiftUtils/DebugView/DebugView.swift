//
//  DebugView.swift
//
//
//  Created by Raul on 16/7/24.
//

import SwiftUI

struct DebugView: View {
    @StateObject var debugHTTPS = DebugViewHTTPS.shared
    
    var body: some View {
        List {
            Section(header: Text("Welcome to Debug View").bold()) {
                NavigationLink(destination: RequestsListView(list: debugHTTPS)) {
                    Text("HTTPS Response")
                }

                NavigationLink(destination: UserDefaultListView()) {
                    Text("UserDefaults Viewer")
                }

                NavigationLink(destination: PushNotificationListView()) {
                    Text("Push Notifications")
                }
            }
        }
        .navigationTitle("Debug view")
    }
}
