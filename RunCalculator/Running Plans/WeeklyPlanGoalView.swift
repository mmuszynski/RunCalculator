//
//  WeeklyPlanGoalView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/17/23.
//

import SwiftUI

struct WeeklyPlanGoalView: View {
    var goal: WeeklyPlanGoal
    var body: some View {
        VStack {
            Text(goal.dateInterval, formatter: .shortDateFormatter)
            Text(goal.plannedMileageMeasurement, formatter: .mileageFormatter)
                .font(.largeTitle)
                .padding()
        }
        .padding()
        .background(Color
            .white
            .cornerRadius(20)
            .shadow(radius: 8.0)
            .opacity(0.25)
        )
    }
}

struct WeeklyPlanGoalView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyPlanGoalView(goal: WeeklyPlanGoal(dateInterval: Calendar.current.dateInterval(of: .weekOfYear, for: Date())!, plannedMileage: 5))
            .previewLayout(.sizeThatFits)
    }
}
