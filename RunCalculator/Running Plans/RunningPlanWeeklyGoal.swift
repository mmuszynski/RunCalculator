//
//  RunningPlanWeeklyGoal.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/25/23.
//

import Foundation

struct RunningPlanWeeklyGoal: Codable {
    var days: [RunningPlanDailyGoal]
    
    var totalMileage: Double {
        days.reduce(0) { partialResult, next in
            return partialResult + next.miles
        }
    }
    
    var weekIndex: Int {
        set {
            days = days.map {
                var day = $0
                day.week = newValue
                return day
            }
        }
        get {
            return days.first?.week ?? 0
        }
    }
    
    static var empty: RunningPlanWeeklyGoal {
        var week = RunningPlanWeeklyGoal(days: [])
        for day in 0..<7 {
            week.days.append(RunningPlanDailyGoal(miles: 0, day: day, week: 0))
        }
        return week
    }
}
