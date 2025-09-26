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
                Text("Short by ") +
                Text(vc.goalMileageRemaining, formatter: vc.mileageFormatter)
            } else {
                Text("Success! 🎉")
            }
            
            let count = vc.workoutsDuringInterval.count
            Text("\(count) runs (") +
            Text(vc.mileageTowardsGoal / Double(count), formatter: vc.mileageFormatter)
            Text(" per run)")
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
