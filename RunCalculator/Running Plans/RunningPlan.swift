//
//  RunningPlan.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/6/23.
//

import Foundation

struct RunningPlan: Codable {
    var weeklyGoals: [RunningPlanWeeklyGoal] = [.empty]
    
    mutating func add(_ week: RunningPlanWeeklyGoal) {
        let weekIndex = weeklyGoals.count
        var week = week
        week.weekIndex = weekIndex
        self.weeklyGoals.append(week)
    }
    
    private static var dayFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "eeeee"
        return df
    }
    
    static func dayDescription(dayIndex day: Int) -> String? {
        guard let date = Calendar.current.date(from: DateComponents(year: 2000, weekday: day + 1, weekOfYear: 1)) else { return nil }
        return Self.dayFormatter.string(from: date)
    }
}
