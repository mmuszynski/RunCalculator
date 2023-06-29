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
    
    var body: some View {
        VStack {
            Chart(hdc.cachedChartData) {                RuleMark(x: .value("Today", Date().dayOfYear!))
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
        .chartScrollTargetBehavior(.valueAligned(unit: 25))
        .chartScrollableAxes([.horizontal, .vertical])
        .chartXVisibleDomain(length: 100)
        .chartYVisibleDomain(length: 100)
        .chartScrollPosition(initialX: max(0,Date().dayOfYear!-75))
        .chartScrollPosition(initialY: max(100,hdc.calculator.mileageAsOfToday + 50))
        .padding()
        
        
    }
}

struct MileageChart_Previews: PreviewProvider {
    static var previews: some View {
        MileageChart()
            .environmentObject(HealthDataController())
    }
}
