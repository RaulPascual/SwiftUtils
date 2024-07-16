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
                        NavigationLink(destination: buildRequestList()) {
                            Text(item.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("Debug view")
    }
    
    @ViewBuilder
    func buildRequestList() -> some View {
        VStack {
            clearButton
            requestListScrollView
        }
    }

    private var clearButton: some View {
        HStack {
            Button {
                DebugViewHTTPS.shared.requestsList.removeAll()
            } label: {
                Image(systemName: "trash.fill")
                    .accessibilityHidden(true)
            }
        }
    }

    private var requestListScrollView: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(debugHTTPS.requestsList.reversed(), id: \.id) { item in
                    requestInformation(for: item)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity)
    }
    
    private func requestInformation(for item: DebugViewHTTPS.Request) -> some View {
        VStack {
            HStack {
                Text(item.method)
                    .padding(.all, 4)
                Text(item.response?.statusCode ?? "")
                    .bold()
                    .padding(.all, 4)
            }
            
            Text(item.endpoint)
            
            Text(item.date, format: .dateTime)
                .foregroundStyle(.black)
                .padding()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(statusColor(code: item.response?.statusCode ?? "").opacity(0.1))
        )
        .foregroundStyle(statusColor(code: item.response?.statusCode ?? ""))
    }
    
    private func statusColor(code: String) -> Color {
        switch code {
        case "200", "201", "202", "204", "206":
            return Color.green
            
        default:
            return Color.red
        }
    }
}

struct DebugViewModel {
    let model: [DebugType] = DebugType.allCases
    
    enum DebugType: String, CaseIterable {
        var id: Int { hashValue }
        case httpsResponse = "HTTPS Response"
    }
}

 #if DEV
 extension UIWindow {
    override open var canBecomeFirstResponder: Bool {
        return true
    }

    override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AppCoordinator.shared.isDebugViewActive = true
        }
    }
 }
 #endif
