//
//  CombinedBarChartView.swift
//  SwiftUtilsPackage
//
//  Created by Raul on 15/8/25.
//


import SwiftUI
import Charts

public struct CombinedBarChartView: View {
    let racePointsData: [RacePointsData]
    let barColor: Color
    let chartTitle: LocalizedStringKey
    @State private var chartType: ChartType = .bar
    
    private var maxPoints: Double {
        racePointsData.map(\.points).max() ?? 25.0
    }
    
    private var chartMaxPoints: Double {
        maxPoints + (maxPoints * 0.1)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(chartTitle)
                    .padding(.horizontal)
                Spacer()
                // Chart type picker
                Picker("", selection: $chartType) {
                    Image(systemName: "chart.bar.fill").tag(ChartType.bar)
                    Image(systemName: "chart.line.uptrend.xyaxis").tag(ChartType.line)
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 100)
                .padding(.all, 6)
            }
            
            if !racePointsData.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    Chart(racePointsData) { race in
                        switch chartType {
                        case .bar:
                            BarMark(
                                x: .value("", "R\(race.round)"),
                                y: .value("", race.points)
                            )
                            .foregroundStyle(barColor)
                            .cornerRadius(4)
                            
                        case .line:
                            LineMark(
                                x: .value("", "R\(race.round)"),
                                y: .value("", race.points)
                            )
                            .foregroundStyle(barColor)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                            
                            PointMark(
                                x: .value("", "R\(race.round)"),
                                y: .value("", race.points)
                            )
                            .foregroundStyle(barColor)
                            .symbolSize(50)
                        }
                    }
                    .frame(width: max(CGFloat(racePointsData.count * 30), 200), height: 300)
                    .chartYScale(domain: 0...chartMaxPoints)
                    .chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            AxisGridLine()
                            AxisValueLabel {
                                if let round = value.as(String.self) {
                                    Text(round)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading, values: .stride(by: 5)) { value in
                            AxisGridLine()
                            AxisValueLabel {
                                if let points = value.as(Double.self) {
                                    Text("\(Int(points))")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
            } else {
                EmptyView()
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    CombinedBarChartView(
        racePointsData: [
            RacePointsData(round: "1", raceName: "Bahrain", points: 18.0),
            RacePointsData(round: "2", raceName: "Saudi Arabia", points: 25.0),
            RacePointsData(round: "3", raceName: "Australia", points: 15.0),
            RacePointsData(round: "4", raceName: "Azerbaijan", points: 10.0),
            RacePointsData(round: "5", raceName: "Miami", points: 12.0),
            RacePointsData(round: "6", raceName: "Monaco", points: 8.0),
            RacePointsData(round: "7", raceName: "Spain", points: 25.0),
            RacePointsData(round: "8", raceName: "Canada", points: 18.0)
        ],
        barColor: .green,
        chartTitle: LocalizedStringKey(stringLiteral: "Season progression")
    )
}
