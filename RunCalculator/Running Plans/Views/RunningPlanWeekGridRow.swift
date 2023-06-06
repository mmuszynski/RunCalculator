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
            ZStack {
                Color.clear
                Text("\(week.week)")
                    .fontWeight(.ultraLight)
                    .italic()
            }
            
            ForEach(week.goals) { day in
                RunningPlanDailyView(goal: day, isSelected: controller.selection?.id == day.id)
                    .onTapGesture {
                        controller.selection = day
                    }
            }
            
            ZStack {
                Color.clear
                Text(NSNumber(value: week.totalMiles),
                     formatter: .twoFractionalDigits)
                .bold()
            }
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
