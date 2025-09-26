//
//  YearlyMileageInformationView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/22/23.
//

import SwiftUI

extension MeasurementFormatter {
    static func mileageFormatter(minimumFractionDigits: Int = 0, maximumFractionDigits: Int = 2) -> MeasurementFormatter {
        let formatter = MeasurementFormatter()
        let nf = NumberFormatter()
        nf.maximumFractionDigits = maximumFractionDigits
        nf.minimumFractionDigits = minimumFractionDigits
        formatter.numberFormatter = nf
        return formatter
    }
}

struct MileageInformationView: View {
    @Environment(MileageGoalViewController.self) var vc
    
    var body: some View {
        VStack {
            Group {
                Text(vc.mileageTowardsGoal, formatter: vc.mileageFormatter)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
            }
            .monospacedDigit()
            
            if vc.goal.isUpcoming {
                UpcomingMileageGoalInfoView()
            } else if vc.goal.isExpired {
                PreviousMileageGoalInfoView()
            } else if vc.goalMileageRemaining.value > 0 {
                InProgressMileageGoalInfoView()
            } else {
                Text("Goal Complete! 🎉")
                    .bold()
                    .padding()
            }
        }
        .foregroundStyle(vc.hdc.isDoingWork ? .tertiary : .primary)
    }
}

#Preview {
    MileageInformationView()
        .environment(MileageGoalViewController(hdc: HealthDataController(), goal: .example))
}

#Preview {
    let controller = HealthDataController()
    MileageInformationView()
        .environment(MileageGoalViewController(hdc: controller, goal: .expired))
        .task {
            await controller.loadWorkouts()
        }
}
