//
//  DebugViewHTTPS.swift
//
//
//  Created by Raul on 16/7/24.
//

import SwiftUI

class DebugViewHTTPS: ObservableObject {
    static let shared = DebugViewHTTPS()
    
    @Published var response = "false"
    @Published var responsesList: [Response] = []
    @Published var requestsList: [Request] = []
    
    struct Response: Identifiable {
        let id = UUID()
        var endpoint: String
        var date: Date
        var response: String
        var statusCode: String
        var responseHeaders: [String: String]?
    }
    struct Request: Identifiable {
        let id = UUID()
        var endpoint: String
        var method: String
        var date: Date
        var body: String
        var headers: [String: String]?
        var response: Response?
        var requestOverviewInfo: [String: String]
    }
}
