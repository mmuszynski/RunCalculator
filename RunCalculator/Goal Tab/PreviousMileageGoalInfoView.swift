//
//  PreviousMileageGoalInfoView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 8/19/24.
//

import SwiftUI

struct PreviousMileageGoalInfoView: View {
    @Environment(MileageGoalViewController.self) var vc

    var body: some View {
        VStack {
            if vc.goalMileageRemaining.value > .zero {
                Text("Completed")
                Text("Short by \(vc.goalMileageRemaining, formatter: vc.mileageFormatter)")
            } else {
                Text("Success! 🎉")
            }
            
            let count = vc.workoutsDuringInterval.count
            if count > 0 {
                Text("\(count) runs (\(vc.mileageTowardsGoal / Double(count), formatter: vc.mileageFormatter) per run)")
            } else {
                Text("No runs completed")
            }
        }
        .fontDesign(.rounded)
        .monospacedDigit()
        .onTapGesture {
            vc.hdc.calculator.nextTimeframe()
        }
    }
}

#Preview {
    PreviousMileageGoalInfoView()
        .environment(MileageGoalViewController(hdc: HealthDataController(), goal: .expired))
}
