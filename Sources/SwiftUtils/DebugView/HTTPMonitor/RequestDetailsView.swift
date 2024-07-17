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
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Date:")
                        .bold()
                    Text(requestDetails.response?.date ?? Date.now,
                         format: dateFormat)
                }
                
                HStack {
                    Text("Method:")
                        .bold()
                    Text(requestDetails.method)
                }
                
                HStack {
                    Text("Endpoint:")
                        .bold()
                    Text(requestDetails.endpoint)
                }
                
                HStack {
                    Text("Request Headers:")
                        .bold()
                    Text(requestDetails.headers?.description ?? "No request headers")
                }
            }
            .padding()
            
            
            DisclosureGroup {
                ScrollView {
                    Text(requestDetails.body)
                }
            } label: {
                Text("Request Body:")
                    .bold()
            }
            .padding()
            
            DisclosureGroup {
                ScrollView {
                    Text(requestDetails.response?.response ?? "No response body")
                }
            } label: {
                Text("Response Body:")
                    .bold()
            }
            .padding()
        }
    }
}

#Preview {
    RequestDetailsView(
        requestDetails: DebugViewHTTPS.Request(
            endpoint: "https://api.example.com/resource",
            method: "GET",
            date: Date(),
            body: "{\"key\":\"value\"}",
            headers: ["authToken" : "sdsdsdfds123ew2"],
            response: DebugViewHTTPS.Response(
                endpoint: "https://api.example.com/resource",
                date: Date(),
                response: "{\"responseKey\":\"responseValue\"}",
                statusCode: "200",
                responseHeaders: ["Content-Type": "application/json"]
            ), requestOverviewInfo: ["Content-Type": "application/json"]
        )
    )
}
