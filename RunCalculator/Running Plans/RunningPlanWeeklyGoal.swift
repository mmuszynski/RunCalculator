//
//  RunningPlanWeeklyGoal.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/27/23.
//

import Foundation

struct RunningPlanWeeklyGoal: Codable {
    var goals: [RunningPlanDailyGoal] = []
    var week: Int
    
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
}

extension RunningPlanWeeklyGoal: Identifiable {
    var id: Int {
        week
    }
}
