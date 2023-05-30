//
//  RunningPlanViewController.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/27/23.
//

import Foundation

class RunningPlanViewController: ObservableObject {
    @Published var plan: RunningPlan = RunningPlan()
    @Published var selection: RunningPlanDailyGoal?
    
    func increase(_ daily: RunningPlanDailyGoal?, by amount: Double) {
        guard let daily = daily else { return }
        var week = plan.goals[daily.week]
        var day = week.goals[daily.day]
        
        day.miles += amount
        if day.miles < 0 { day.miles = 0 }
        week.goals[daily.day] = day
        plan.goals[daily.week] = week
        
        self.selection = day
    }
}
