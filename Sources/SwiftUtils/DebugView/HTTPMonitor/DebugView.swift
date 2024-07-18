//
//  DebugView.swift
//  
//
//  Created by Raul on 16/7/24.
//

import SwiftUI

struct DebugView: View {
    let debugViewModel = DebugViewModel()
    @StateObject var debugHTTPS = DebugViewHTTPS.shared
    
    var body: some View {
        List {
            Section(header: Text("Welcome to Debug View").bold()) {
                ForEach(debugViewModel.model, id: \.id) { item in
                    NavigationLink(destination: RequestsListView(list: debugHTTPS)) {
                        Text(item.rawValue)
                    }
                }
            }
        }
        .navigationTitle("Debug view")
    }
}

struct DebugViewModel {
    let model: [DebugType] = DebugType.allCases
    
    enum DebugType: String, CaseIterable {
        var id: Int { hashValue }
        case httpsResponse = "HTTPS Response"
    }
}
