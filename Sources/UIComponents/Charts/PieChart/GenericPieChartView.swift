//
//  GenericPieChartView.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 15/8/25.
//

import SwiftUI
import Charts

struct GenericPieChartView: View {
    let data: [PieChartDataItem]
    let centerLabel: String
    let centerValue: String
    let centerValueColor: Color
    let showSideCards: Bool
    let emptyStateMessage: String
    
    init(
        data: [PieChartDataItem],
        centerLabel: String = "",
        centerValue: String = "",
        centerValueColor: Color = .blue,
        showSideCards: Bool = true,
        emptyStateMessage: String = "GeneralEmptyStateResults"
    ) {
        self.data = data
        self.centerLabel = centerLabel
        self.centerValue = centerValue
        self.centerValueColor = centerValueColor
        self.showSideCards = showSideCards
        self.emptyStateMessage = emptyStateMessage
    }
    
    private var sortedData: [PieChartDataItem] {
        data.sorted { $0.value > $1.value }
    }
    
    private var dataForDisplay: [PieChartDataItem] {
        guard sortedData.count >= 2, showSideCards else {
            return sortedData
        }
        
        // Reorder for better visual distribution (second highest first)
        return [sortedData[1], sortedData[0]] + Array(sortedData.dropFirst(2))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if !sortedData.isEmpty {
                if showSideCards && sortedData.count >= 2 {
                    // Layout with side cards
                    HStack(spacing: 0) {
                        // Left card (highest value)
                        DataCard(
                            data: sortedData[0],
                            isLeft: true
                        )
                        
                        Spacer()
                        
                        CentralPieChart(
                            data: dataForDisplay,
                            centerLabel: centerLabel,
                            centerValue: centerValue,
                            centerValueColor: centerValueColor
                        )
                        
                        Spacer()
                        
                        DataCard(
                            data: sortedData[1],
                            isLeft: false
                        )
                    }
                    .padding(.horizontal)
                }
            } else {
                ContentUnavailableView(emptyStateMessage, systemImage: "exclamationmark.message.fill")
            }
        }
        .padding()
        .cornerRadius(16)
    }
}

struct DataCard: View {
    let data: PieChartDataItem
    let isLeft: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(data.label)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(data.color)
            
            VStack(spacing: 2) {
                Text(String(format: "%.0f", data.value))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                if let subtitle = data.subtitle {
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct CentralPieChart: View {
    let data: [PieChartDataItem]
    let centerLabel: String
    let centerValue: String
    let centerValueColor: Color
    
    private var totalValue: Double {
        data.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Center label and value
            if !centerValue.isEmpty {
                VStack(spacing: 2) {
                    Text(centerValue)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if !centerLabel.isEmpty {
                        Text(centerLabel)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(centerValueColor)
                            .cornerRadius(8)
                    }
                }
            }
            
            Chart(data) { item in
                SectorMark(
                    angle: .value("", item.value),
                    angularInset: 1
                )
                .foregroundStyle(item.color)
            }
            .frame(width: 100, height: 100)
        }
    }
}

#Preview("With Side Cards") {
    GenericPieChartView(
        data: [
            PieChartDataItem(label: "PIA", value: 266.0, color: .orange, subtitle: "(52.1%)"),
            PieChartDataItem(label: "NOR", value: 245.0, color: .orange.opacity(0.6), subtitle: "(47.9%)")
        ],
        centerLabel: "Pts",
        centerValue: "511",
        centerValueColor: .orange,
        showSideCards: true
    )
}

