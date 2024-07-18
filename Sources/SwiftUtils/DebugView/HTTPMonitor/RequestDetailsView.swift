//
//  SwiftUIView.swift
//
//
//  Created by Raul on 17/7/24.
//

import SwiftUI

public struct RequestDetailsView: View {
    let requestDetails: DebugViewHTTPS.Request
    let dateFormat = Date.FormatStyle(date: .numeric, time: .standard).hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits).second(.twoDigits)
    
    public var body: some View {
        let requestDate = requestDetails.date
        let responseDate = requestDetails.response?.date

        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Group {
                    HStack {
                        Text("Request date:").bold()
                        Text(requestDate, format: dateFormat)
                    }
                    
                    HStack {
                        Text("Response date:").bold()
                        if let responseDate = responseDate {
                            Text(responseDate, format: dateFormat)
                        } else {
                            Text("nil")
                        }
                    }
                    
                    if let responseDate = responseDate {
                        HStack {
                            Text("Duration:").bold()
                            Text(elapsedTime(from: requestDate, to: responseDate))
                        }
                    }
                    
                    HStack {
                        Text("Method:").bold()
                        Text(requestDetails.method)
                    }
                    .padding(.bottom, 4)
                    
                    VStack(alignment: .leading) {
                        Text("Endpoint:").bold()
                        Text(requestDetails.endpoint)
                    }
                    .padding(.bottom, 4)
                    
                    VStack(alignment: .leading) {
                        Text("Request Headers:").bold()
                        Text(requestDetails.headers?.description ?? "No request headers")
                    }
                }
                .padding(.horizontal)
                
                Group {
                    DisclosureGroup {
                        ScrollView {
                            Text(requestDetails.body)
                        }
                    } label: {
                        Text("Request Body:").bold()
                    }
                    .padding()
                    
                    DisclosureGroup {
                        ScrollView {
                            Text(requestDetails.response?.response ?? "No response body")
                        }
                    } label: {
                        Text("Response Body:").bold()
                    }
                    .padding()
                }
            }
        }
    }
    
    private func elapsedTime(from startDate: Date, to endDate: Date) -> String {
        let interval = endDate.timeIntervalSince(startDate) // Diff in seconds
        
        if interval < 1 {
            let milliseconds = Int(interval * 1000) // sec to ms
            return "\(milliseconds) ms"
        } else {
            let seconds = String(format: "%.2f", interval)
            return "\(seconds) sec"
        }
    }
}

#Preview {
    RequestDetailsView(
        requestDetails: DebugViewHTTPS.Request(
            endpoint: "https://api.example.com/resource",
            method: "GET",
            date: Date(timeIntervalSinceNow: 0),
            body: "{\"key\":\"value\"}",
            headers: ["authToken" : "sdsdsdfds123ew2"],
            response: DebugViewHTTPS.Response(
                endpoint: "https://api.example.com/resource",
                date: Date(timeIntervalSinceNow: 1),
                response: "{\"responseKey\":\"responseValue\"}",
                statusCode: "200",
                responseHeaders: ["Content-Type": "application/json"]
            ), requestOverviewInfo: ["Content-Type": "application/json"]
        )
    )
}
