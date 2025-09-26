//
//  RunningPlanListDetailView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 7/2/23.
//

import SwiftUI

struct RunningPlanListDetailView: View {
    @EnvironmentObject var controller: RunningPlanController
    var plan: RunningPlan
    var body: some View {
        VStack {
            NavigationLink(plan.name, value: plan)
                .fontWeight(.regular)
            HStack(spacing: 0) {
                TextWithImage("\(plan.goals.count) weeks",
                              image: "calendar")
                Spacer()
                TextWithImage("\(plan.runCount) runs",
                              image: "figure.run.square.stack",
                              placement: .trailing)
            }
            .decorativeImageWidth(30)
            
            HStack(spacing: 0) {
                TextWithImage("\(Formatter.twoFractionalDigits.string(for: plan.totalMileage)!) miles", image: "figure.walk.motion")
                Spacer()
                Text(NSNumber(value: plan.milesPerRun), formatter: .twoFractionalDigits)
                TextWithImage(" mi/run", image: "figure.run", placement: .trailing)
            }
            .decorativeImageWidth(30)
            
            if plan == controller.selectedPlan?.plan {
                Text("Active Plan")
                    .italic()
            }
        }
        .fontWeight(.thin)
    }
}

struct RunningPlanListDetailViewPreview: PreviewProvider {
    static var previews: some View {
        RunningPlanListDetailView(plan: .monumental)
            .environmentObject(RunningPlanController())
    }
}
