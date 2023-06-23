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

struct MileageChart: View {
    @EnvironmentObject var hdc: HealthDataController
    var mileageCalculator = YearlyMileageCalculator()
        
    var body: some View {
        VStack {
            Chart(hdc.cachedChartData) {
                RuleMark(x: .value("Today", Date().dayOfYear!))
                    .foregroundStyle(.quaternary)
                LineMark(x: .value("Date", $0.day),
                         y: .value("Distance", $0.mileage),
                         series: .value("Group", $0.group))
                .foregroundStyle(by: .value("Group", $0.group))
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
        .chartScrollPosition(initialY: 100)
        .padding()
            
        
    }
}

struct MileageChart_Previews: PreviewProvider {
    static var previews: some View {
        MileageChart()
            .environmentObject(HealthDataController())
    }
}
