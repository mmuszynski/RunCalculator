//
//  RunningPlanHeader.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/29/23.
//

import SwiftUI

struct RunningPlanHeader: View {
    @EnvironmentObject var viewController: RunningPlanController
    
    var plan: RunningPlan = .monumental
    var body: some View {
        VStack(alignment: .leading) {
            if viewController.selectedPlan?.plan == plan {
                Text("This plan is currently active")
                    .italic()
            }
            HStack {
                Text("\(plan.runCount) activities")
                Spacer()
                Text(plan.totalMileage.miles, formatter: .mileageFormatter)
            }
        }
    }
}

struct RunningPlanHeaderPreview: PreviewProvider {
    static var previews: some View {
        RunningPlanHeader()
            .environmentObject(RunningPlanController())
    }
}
