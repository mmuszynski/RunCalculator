//
//  RunningPlanWeekGridRow.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/27/23.
//

import SwiftUI

struct RunningPlanWeekGridRow: View {
    @EnvironmentObject var controller: RunningPlanViewController
    var week: RunningPlanWeeklyGoal
    
    var body: some View {
        GridRow {
            Text("\(week.week + 1)")
            ForEach(week.goals) { day in
                RunningPlanDailyView(goal: day, isSelected: controller.selection == day)
                    .onTapGesture {
                        controller.selection = day
                    }
            }
            Text(NSNumber(value: week.totalMiles),
                 formatter: .twoFractionalDigits)
        }
        .transition(.scale)
    }
}

struct RunningPlanWeekGridRow_Previews: PreviewProvider {
    static var previews: some View {
        Grid {
            RunningPlanWeekGridRow(week: {
                var plan = RunningPlan()
                plan.addWeek()
                return plan.goals.first!
            }())
            .environmentObject(RunningPlanViewController())
        }
    }
}
