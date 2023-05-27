//
//  RunningPlanView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/16/23.
//

import SwiftUI

struct RunningPlanView: View {
    @State var plan: RunningPlan
    @State var selection: RunningPlanDailyGoal?
    
    var body: some View {
        ScrollView {
            Grid(horizontalSpacing: 0) {
                GridRow {
                    Text("Wk")
                    RunningPlanHeaderView()
                }
                
                Divider()
                    .gridCellUnsizedAxes(.horizontal)
                
                ForEach(plan.weeklyGoals.indices, id: \.self) { index in
                    GridRow {
                        RunningPlanWeekView(week: plan.weeklyGoals[index],
                                            weekIndex: index,
                                            selection: $selection)
                        .frame(width: 40)
                    }
                }
                
                GridRow {
                    Button("Add a week") { plan.add(.empty) }
                        .gridCellColumns(10)
                }
            }
            .font(.title2)
        }
        .onTapGesture {
            selection = nil
        }
    }
}

struct RunningPlanView_Previews: PreviewProvider {
    static var previews: some View {
        RunningPlanView(plan: {
            var plan = RunningPlan()
            plan.add(.empty)
            return plan
        }())
    }
}
