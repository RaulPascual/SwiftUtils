//
//  SwiftUIView.swift
//
//
//  Created by Raul on 17/7/24.
//

import SwiftUI

struct RequestsListView: View {
    var list: DebugViewHTTPS
    
    var body: some View {
        VStack {
            requestListScrollView
        }
        .padding(.horizontal)
    }
    
    private var requestListScrollView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(list.requestsList.reversed(), id: \.id) { item in
                    
                    NavigationLink {
                        RequestDetailsView(requestDetails: item)
                    } label: {
                        requestInformation(for: item)
                    }
                }
            }
        }
    }
    
    private func requestInformation(for item: DebugViewHTTPS.Request) -> some View {
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
