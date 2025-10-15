//
//  SwiftUIView.swift
//
//
//  Created by Raul on 17/7/24.
//

#if os(iOS)
import SwiftUI

public struct RequestDetailsView: View {
    let requestDetails: DebugViewHTTPS.Request
    let dateFormat = Date.FormatStyle(date: .numeric, time: .standard).hour(.twoDigits(amPM: .abbreviated)).minute(.twoDigits).second(.twoDigits)
    
    public var body: some View {
        let requestDate = requestDetails.date
        let responseDate = requestDetails.response?.date ?? Date()
        
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Group {
                    RequestLineInformationView(lineTitle: "Request date:", lineDate: requestDate)
                    
                    RequestLineInformationView(lineTitle: "Response date:", lineDate: responseDate)
                    
                    RequestLineInformationView(lineTitle: "Duration:",
                                           lineInformation: elapsedTime(from: requestDate,
                                                                        to: responseDate))
                    
                    RequestLineInformationView(lineTitle: "Method:", lineInformation: requestDetails.method)
                    
                    RequestLineInformationView(lineTitle: "Endpoint:", lineInformation: requestDetails.endpoint)
                }
                .padding(.horizontal)
                
                Group {
                    BodyDisclosureGroup(title: "Request Headers:", 
                                        bodyText: requestDetails.headers?.description ?? "No request headers")
                    
                    BodyDisclosureGroup(title: "Response Headers:", 
                                        bodyText: requestDetails.response?.responseHeaders?.description ?? "No response headers")
                    
                    BodyDisclosureGroup(title: "Request Body:",
                                        bodyText: requestDetails.body)
                    
                    BodyDisclosureGroup(title: "Response Body:", 
                                        bodyText: requestDetails.response?.response ?? "No response body")
                }
            }
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
    
    var body: some View {
        DisclosureGroup {
            ScrollView {
                Text(bodyText)
                    .textSelection(.enabled)
            }
        } label: {
            Text(title).bold()
        }
        .padding()
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
        HStack {
            Text(lineTitle)
                .bold()
            if let date = lineDate {
                Text(date, format: RequestLineInformationView.dateFormat)
            } else {
                Text(lineInformation ?? "(nil)")
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
#endif
