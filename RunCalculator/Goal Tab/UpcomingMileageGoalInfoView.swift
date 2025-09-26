//
//  UpcomingMileageGoalInfoView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 8/19/24.
//

import SwiftUI

struct UpcomingMileageGoalInfoView: View {
    @Environment(MileageGoalViewController.self) var vc

    var body: some View {
        VStack {
            Text(vc.goalMileageRemaining, formatter: vc.mileageFormatter) +
            Text(" remaining")
            Text(" over ") +
            Text("\(vc.timeRemaining) weeks")
            
            Spacer()
                .frame(height: 10)
            Text(vc.remainingMileageRate(per: .weekOfYear), formatter: vc.mileageFormatter) +
            Text("/wk") +
            Text(" to reach goal")
                .fontWeight(.semibold)
            
            Text(vc.mileageAgainstPace.value > 0 ? vc.mileageAgainstPace : -1 * vc.mileageAgainstPace , formatter: vc.mileageFormatter) +
            Text(vc.mileageAgainstPace.value < 0 ? " ahead of pace" : " behind pace")
        }
        .fontDesign(.rounded)
        .monospacedDigit()
        .onTapGesture {
            vc.hdc.calculator.nextTimeframe()
        }
    }
}

#Preview {
    UpcomingMileageGoalInfoView()
        .environment(MileageGoalViewController(hdc: HealthDataController(), goal: .example))
}
