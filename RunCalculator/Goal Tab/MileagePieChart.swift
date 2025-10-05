//
//  MileagePieChart.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 7/26/24.
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
    
    var overcompletionSectorMark: SectorMark {
        SectorMark(angle: .value(self.name, self.value),
                       innerRadius: .ratio(0.9))
    }
}

struct MileagePieChart: View {
    enum Style {
        case full
        case minimal
    }
    
    @Environment(MileageGoalViewController.self) var vc
    var style: Style = .full
    
    var body: some View {
        Chart {
            SectorMark(angle: .value("Zero", 1),
                       innerRadius: .ratio(0.8))
            PieGraphElement(name: "Completed", value: min(vc.mileageTowardsGoal.value, vc.goal.target))
                .sectorMark
                .foregroundStyle(.primary)
            PieGraphElement(name: "Remaining", value: max(0, vc.goalMileageRemaining.value))
                .sectorMark
                .foregroundStyle(.tertiary)
            /*PieGraphElement(name: "Overdone", value: min(0, vc.goalMileageRemaining.value))
                .overcompletionSectorMark
                .foregroundStyle(.primary.secondary)*/
        }
        .foregroundStyle(.red)
        .chartBackground { chart in
            if style == .full {
                MileageInformationView()
            }
        }
    }
}

#Preview("Example") {
    MileagePieChart()
        .environment(MileageGoalViewController(hdc: HealthDataController(), goal: .example))
}

#Preview("Expired") {
    MileagePieChart()
        .environment(MileageGoalViewController(hdc: HealthDataController(), goal: .expired))
}

#Preview {
    NavigationStack {
        VStack {
            MileagePieChart()
                .aspectRatio(contentMode: .fit)
                .border(.black)
                .padding()
            Spacer()
        }
        .environment(MileageGoalViewController(hdc: HealthDataController(), goal: .example))
        .navigationTitle(Text("Goal: \(MileageGoal.example.measurement, formatter: .mileageFormatter)"))
        .navigationSubtitle(Text(MileageGoal.example.interval, formatter: DateIntervalFormatter(timeStyle: .none, dateStyle: .short)))
    }
}
