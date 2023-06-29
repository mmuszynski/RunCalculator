//
//  YearlyMileagePieChart.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/22/23.
//

import SwiftUI
import Charts

fileprivate struct PieGraphElement {
    var name: String
    var value: Double
    
    var sectorMark: SectorMark {
        SectorMark(angle: .value(self.name, self.value),
                   innerRadius: .ratio(0.8))
    }
}

struct YearlyMileagePieChart: View {
    @EnvironmentObject var hdc: HealthDataController
    var body: some View {
        ZStack {
            Chart {
                SectorMark(angle: .value("Zero", 1),
                           innerRadius: .ratio(0.8))
                PieGraphElement(name: "Completed", value: hdc.calculator.mileageAsOfToday)
                    .sectorMark
                    .foregroundStyle(.primary)
                PieGraphElement(name: "Remaining", value: hdc.calculator.mileageRemainingAsOfToday)
                    .sectorMark
                    .foregroundStyle(.tertiary)
            }
            .foregroundStyle(.red)
            .chartBackground(content: { chart in
                YearlyMileageInformationView()
            })
        }
        .padding()
        .task {
            await hdc.loadWorkouts()
        }
    }
}

#Preview {
    YearlyMileagePieChart()
        .environmentObject(HealthDataController())
}
