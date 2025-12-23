//
//  SwiftUIView.swift
//
//
//  Created by Raul on 17/7/24.
//

import SwiftUI

struct RequestsListView: View {
    @ObservedObject var list: DebugViewHTTPS
    let requestTypes = ["ALL", "GET", "POST", "PUT", "DELETE"]
    @State private var selectedRequestType = "ALL"
    @State private var filteredEndpoint = ""
    
    var filteredRequests: [DebugViewHTTPS.Request] {
        list.requestsList.filter { request in
            (selectedRequestType == "ALL" || request.method == selectedRequestType) &&
            (filteredEndpoint.isEmpty || request.endpoint.contains(filteredEndpoint))
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            TextField(text: $filteredEndpoint,
                      prompt: Text("Filter by endpoint"),
                      label: {
                Text("Filter by endpoint")
            })
            .textFieldStyle(.roundedBorder)
            
            Picker("Request Type", selection: $selectedRequestType) {
                ForEach(requestTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(.segmented)
            
            ScrollView {
                VStack(alignment: .leading) {
                    if list.requestsList.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.secondary)
                                .font(.system(size: 50))
                            
                            Text("No requests registered yet")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        ForEach(filteredRequests.reversed(), id: \.id) { item in
                            NavigationLink {
                                RequestDetailsView(requestDetails: item)
                            } label: {
                                requestInformationLabel(for: item)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("HTTPS Response")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .destructive) {
                    list.clearAllRequests()
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(list.requestsList.isEmpty)
            }
        }
    }
    
    private func requestInformationLabel(for item: DebugViewHTTPS.Request) -> some View {
        let statusColor = self.statusColor(code: item.response?.statusCode ?? "")
        let dateFormat = Date.FormatStyle(date: .numeric, time: .standard).hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits).second(.twoDigits)
        return VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text(item.method)
                
                Text(item.response?.statusCode ?? "---")
            }
            
            Text(item.endpoint)
                .lineLimit(3)
                .multilineTextAlignment(.center)
            
            Text(item.date, format: dateFormat)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(statusColor.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(statusColor.opacity(0.2), lineWidth: 1)
                )
        )
        .foregroundColor(statusColor)
    }
    
    private func statusColor(code: String) -> Color {
        let successCodes: Set<String> = ["200", "201", "202", "204", "206"]
        
        return successCodes.contains(code) ? .green : .red
    }
}

#Preview("With requests") {
    let sampleList = DebugViewHTTPS()
    let _ = {
        sampleList.requestsList = [
            DebugViewHTTPS.Request(
                endpoint: "https://api.example.com/users",
                method: "GET",
                date: Date(),
                body: "",
                headers: ["Authorization": "Bearer token"],
                response: DebugViewHTTPS.Response(
                    endpoint: "https://api.example.com/users",
                    date: Date(),
                    response: "{\"users\": []}",
                    statusCode: "200",
                    responseHeaders: nil
                ),
                requestOverviewInfo: [:]
            ),
            DebugViewHTTPS.Request(
                endpoint: "https://api.example.com/posts",
                method: "POST",
                date: Date(),
                body: "{\"title\": \"Hello\"}",
                headers: nil,
                response: DebugViewHTTPS.Response(
                    endpoint: "https://api.example.com/posts",
                    date: Date(),
                    response: "Not Found",
                    statusCode: "404",
                    responseHeaders: nil
                ),
                requestOverviewInfo: [:]
            )
        ]
    }()
    NavigationStack {
        RequestsListView(list: sampleList)
    }
}

#Preview("Empty") {
    NavigationStack {
        RequestsListView(list: DebugViewHTTPS())
    }
}
