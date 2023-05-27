//
//  RunningPlanWeekView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/25/23.
//

import SwiftUI

struct RunningPlanWeekView: View {
    var week: RunningPlanWeeklyGoal
    var weekIndex: Int
    
    @Binding var selection: RunningPlanDailyGoal?
    
    var body: some View {
        Text("\(weekIndex+1)")
            .foregroundColor(.secondary)
        ForEach(week.days, id: \.self) { goal in
            RunningPlanDailyView(goal: goal,
                                 isSelected: goal == selection)
            .onTapGesture {
                selection = goal
            }
        }
        Text(week.totalMileage.adaptivePrecisionString)
    }
}

struct RunningPlanWeekView_Previews: PreviewProvider {
    static var previews: some View {
        RunningPlanWeekView(week: .empty, weekIndex: 0, selection: .constant(nil))
            .previewLayout(.sizeThatFits)
    }
}
