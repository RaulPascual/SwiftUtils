//
//  DebugViewHTTPS.swift
//
//
//  Created by Raul on 16/7/24.
//

import SwiftUI

@MainActor
final class DebugViewHTTPS: ObservableObject {
    public static let shared = DebugViewHTTPS()
    
    @Published var responsesList: [Response] = []
    @Published var requestsList: [Request] = []
    
    struct Request: Identifiable, Hashable, Sendable {
        static func == (lhs: Request, rhs: Request) -> Bool {
            return lhs.date == rhs.date &&
            lhs.endpoint == rhs.endpoint &&
            lhs.method == rhs.method &&
            lhs.body == rhs.body &&
            lhs.id == rhs.id
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(endpoint)
            hasher.combine(method)
            hasher.combine(date)
            hasher.combine(body)
            hasher.combine(headers)
            hasher.combine(requestOverviewInfo)
        }
        
        let id = UUID()
        var endpoint: String
        var method: String
        var date: Date
        var body: String
        var headers: [String: String]?
        var response: Response?
        var requestOverviewInfo: [String: String]
    }
    
    struct Response: Identifiable, Sendable {
        let id = UUID()
        var endpoint: String
        var date: Date?
        var response: String
        var statusCode: String
        var responseHeaders: [String: String]?
    }
    
    func addRequestToList(request: Request) {
        self.requestsList.append(request)
    }
    
    func clearAllRequests() {
        self.requestsList.removeAll()
    }
}
