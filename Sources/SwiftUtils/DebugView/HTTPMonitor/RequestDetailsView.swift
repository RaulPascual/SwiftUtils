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
        let responseDate = requestDetails.response?.date ?? Date()
        
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(spacing: 0) {
                    RequestLineInformationView(lineTitle: "Request date", lineDate: requestDate)
                    Divider().padding(.vertical, 8)
                    RequestLineInformationView(lineTitle: "Response date", lineDate: responseDate)
                    Divider().padding(.vertical, 8)
                    RequestLineInformationView(lineTitle: "Duration",
                                               lineInformation: elapsedTime(from: requestDate,
                                                                            to: responseDate))
                    Divider().padding(.vertical, 8)
                    RequestLineInformationView(lineTitle: "Method", lineInformation: requestDetails.method)
                    Divider().padding(.vertical, 8)
                    RequestLineInformationView(lineTitle: "Endpoint", lineInformation: requestDetails.endpoint)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                
                VStack(spacing: 8) {
                    BodyDisclosureGroup(title: "Request Headers",
                                        bodyText: requestDetails.headers?.description ?? "No request headers")
                    
                    BodyDisclosureGroup(title: "Response Headers",
                                        bodyText: requestDetails.response?.responseHeaders?.description ?? "No response headers")
                    
                    BodyDisclosureGroup(title: "Request Body",
                                        bodyText: requestDetails.body)
                    
                    BodyDisclosureGroup(title: "Response Body",
                                        bodyText: requestDetails.response?.response ?? "No response body",
                                        searchable: true)
                }
            }
            .padding(.vertical)
        }
    }
    
    /**
     Calculates the elapsed time between two dates and returns a formatted string.
     
     This function calculates the time interval between two given dates. If the interval is less than one second, it returns the elapsed time in milliseconds. Otherwise, it returns the elapsed time in seconds with two decimal places.
     
     - Parameters:
     - startDate: The start date.
     - endDate: The end date.
     - Returns: A formatted string representing the elapsed time in either milliseconds or seconds.
     */
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

struct BodyDisclosureGroup: View {
    var title: String
    var bodyText: String
    var searchable: Bool = false
    
    @State private var searchText = ""
    
    private var matchCount: Int {
        guard !searchText.isEmpty else { return 0 }
        return bodyText.lowercased().components(separatedBy: searchText.lowercased()).count - 1
    }
    
    private var highlightedText: AttributedString {
        var attributed = AttributedString(bodyText)
        guard !searchText.isEmpty else { return attributed }
        
        var searchRange = attributed.startIndex..<attributed.endIndex
        while let range = attributed[searchRange].range(of: searchText, options: .caseInsensitive) {
            attributed[range].backgroundColor = .yellow
            attributed[range].foregroundColor = .black
            searchRange = range.upperBound..<attributed.endIndex
        }
        return attributed
    }
    
    var body: some View {
        DisclosureGroup {
            VStack(spacing: 8) {
                if searchable {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search...", text: $searchText)
                            .textFieldStyle(.plain)
                        if !searchText.isEmpty {
                            Text("\(matchCount)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray5))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                ScrollView {
                    Text(highlightedText)
                        .font(.system(.caption, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }
                .frame(maxHeight: 200)
            }
        } label: {
            Text(title)
                .font(.subheadline.bold())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}

public struct RequestLineInformationView: View {
    var lineTitle: String
    var lineInformation: String? = nil
    var lineDate: Date? = nil
    
    static let dateFormat = Date.FormatStyle(date: .numeric, time: .standard)
        .hour(.twoDigits(amPM: .abbreviated))
        .minute(.twoDigits)
        .second(.twoDigits)
    
    public var body: some View {
        HStack(alignment: .top) {
            Text(lineTitle)
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
            Spacer()
            if let date = lineDate {
                Text(date, format: RequestLineInformationView.dateFormat)
                    .font(.subheadline)
            } else {
                Text(lineInformation ?? "(nil)")
                    .font(.subheadline)
                    .multilineTextAlignment(.trailing)
            }
        }
        .textSelection(.enabled)
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
