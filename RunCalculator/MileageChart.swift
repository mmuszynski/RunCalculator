//
//  MileageChart.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/4/23.
//

import SwiftUI
import Charts
import HealthKit

struct ChartPoint: Identifiable {
    var id: UUID = UUID()
    var day: Int
    var mileage: Double
    var group: String
}

var color = Color(white: 0.8)

struct MileageChart: View {
    @EnvironmentObject var hdc: HealthDataController
    @State private var zoomLevel: Double = 1.0

    private var initialX: Double {
        max(0,Double(Date.current.dayOfYear!)-(25 / zoomLevel))
    }
    private var initialY: Double { max(100,hdc.calculator.mileageAsOfToday - (40 / zoomLevel))
    }
    
    var body: some View {
        VStack {
            Chart(hdc.cachedChartData) {
                RuleMark(x: .value("Today", Date.current.dayOfYear!))
                    .foregroundStyle(.tertiary)
                    .annotation(alignment: .center) {
                        Text("Today")
                            .font(.caption)
                    }
                    .lineStyle(StrokeStyle(dash: [5]))
                
                LineMark(x: .value("Date", $0.day),
                         y: .value("Distance", $0.mileage),
                         series: .value("Group", $0.group))
                .foregroundStyle(by: .value("Group", $0.group))
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
        }
        .task {
            await hdc.calculateChartData()
        }
        .chartScrollTargetBehavior(.valueAligned(unit: 10))
        .chartScrollableAxes([.horizontal, .vertical])
        .chartXVisibleDomain(length: 100 / zoomLevel)
        .chartYVisibleDomain(length: 100 / zoomLevel)
        .chartScrollPosition(initialX: initialX)
        .chartScrollPosition(initialY: initialY)
        .padding()
        
        
    }
}

struct MileageChart_Previews: PreviewProvider {
    static var previews: some View {
        MileageChart()
            .environmentObject(HealthDataController())
    }
}
