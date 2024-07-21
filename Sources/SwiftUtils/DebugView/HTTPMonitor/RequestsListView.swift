//
//  SwiftUIView.swift
//
//
//  Created by Raul on 17/7/24.
//

import SwiftUI
import UIComponents

struct RequestsListView: View {
    var list: DebugViewHTTPS
    let requestTypes = ["GET", "POST", "PUT", "DELETE"]
    @State private var selectedRequestType = "GET"
    @State private var filteredEndpoint = ""
    
    var filteredRequests: [DebugViewHTTPS.Request] {
        list.requestsList.filter { request in
            request.method == selectedRequestType && (filteredEndpoint.isEmpty || request.endpoint.contains(filteredEndpoint))
        }
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $filteredEndpoint,
                      placeholder: "Filter by endpoint")
            .padding(.bottom, 6)
            
            Picker("Request Type", selection: $selectedRequestType) {
                ForEach(requestTypes, id: \.self) { type in
                    Text(type).tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            ScrollView {
                VStack(alignment: .leading) {
                    if list.requestsList.isEmpty {
                        VStack(alignment: .center) {
                            Text("Ups! There is no request or response registered yet.")
                            
                            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.gray)
                                .font(.system(size: 60))
                        }
                    } else {
                        ForEach(filteredRequests, id: \.id) { item in
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
        .padding(.horizontal)
    }
    
    private func requestInformationLabel(for item: DebugViewHTTPS.Request) -> some View {
        let statusColor = self.statusColor(code: item.response?.statusCode ?? "")
        let dateFormat = Date.FormatStyle(date: .numeric, time: .standard).hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits).second(.twoDigits)
        return VStack {
            HStack {
                Text(item.method)
                    .padding(.all, 4)
                Text(item.response?.statusCode ?? "")
                    .bold()
                    .padding(.all, 4)
            }
            
            Text(item.endpoint)
            
            Text(item.date, format: dateFormat)
                .foregroundColor(.black)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(statusColor.opacity(0.1))
        )
        .foregroundColor(statusColor)
        .padding(.vertical, 4)
    }
    
    private func statusColor(code: String) -> Color {
        let successCodes: Set<String> = ["200", "201", "202", "204", "206"]
        
        return successCodes.contains(code) ? .green : .red
    }
}
