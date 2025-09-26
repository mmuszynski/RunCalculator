//
//  RunningPlanWeeklyGoal.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/27/23.
//

import Foundation

class RunningPlanWeeklyGoal: Codable, ExpressibleByArrayLiteral {
    var goals: [RunningPlanDailyGoal] = []
    var week: Int {
        didSet {
            self.goals = self.goals.map { goal in
                RunningPlanDailyGoal(miles: goal.miles, day: goal.day, week: self.week)
            }
        }
    }
    
    init(index weekIndex: Int = 0, dailyMiles: Double = 0) {
        self.week = weekIndex
        for day in 0..<7 {
            goals.append(.init(miles: dailyMiles, day: day, week: weekIndex))
        }
    }
    
    var totalMiles: Double {
        goals.reduce(0) { partialResult, next in
            partialResult + next.miles
        }
    }
    
    init(_ elements: [Int]) {
        self.week = 0
        var newGoals = elements.enumerated().map { (day, miles) in RunningPlanDailyGoal(miles: Double(miles), day: day, week: self.week)}
        while newGoals.count < 7 {
            newGoals.append(RunningPlanDailyGoal(miles: 0, day: newGoals.count, week: self.week))
        }
        self.goals = newGoals
    }
    
    required init(arrayLiteral elements: Double...) {
        self.week = 0
        var newGoals = elements.enumerated().map { (day, miles) in RunningPlanDailyGoal(miles: miles, day: day, week: self.week)}
        while newGoals.count < 7 {
            newGoals.append(RunningPlanDailyGoal(miles: 0, day: newGoals.count, week: self.week))
        }
        self.goals = newGoals
    }
}

extension RunningPlanWeeklyGoal: Identifiable {
    var id: Int {
        week
    }
}
