//
//  RunningPlan.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/6/23.
//

import Foundation

struct RunningPlan: Codable {
    var goals: [RunningPlanWeeklyGoal] = []
    
    mutating func addWeek() {
        goals.append(RunningPlanWeeklyGoal(index: goals.count))
    }
    
    private static var dayFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "eeeee"
        return df
    }
    
    private static var longDayFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "eeee"
        return df
    }
    
    static func dayDescription(dayIndex day: Int) -> String? {
        guard let date = Calendar.current.date(from: DateComponents(weekday: day + 1, weekOfYear: 1)) else { return nil }
        return Self.dayFormatter.string(from: date)
    }
    
    static func longDayDescription(dayIndex day: Int) -> String? {
        guard let date = Calendar.current.date(from: DateComponents(weekday: day + 1, weekOfYear: 1)) else { return nil }
        return Self.longDayFormatter.string(from: date)
    }
}
