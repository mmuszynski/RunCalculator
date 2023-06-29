//
//  RunningPlan.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/6/23.
//

import Foundation

struct RunningPlan: Codable {
    var name: String = "New Plan"
    var goals: [RunningPlanWeeklyGoal] = []
    
    mutating func addWeek(_ week: RunningPlanWeeklyGoal? = nil) {
        if var week {
            week.week = goals.count
            goals.append(week)
        } else {
            goals.append(RunningPlanWeeklyGoal(index: goals.count))
        }
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

extension RunningPlan: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: RunningPlanWeeklyGoal...) {
        var plan = RunningPlan()
        for week in elements {
            plan.addWeek(week)
        }
        self = plan
    }
}

extension RunningPlan {
    static var example: RunningPlan {
        var plan = RunningPlan()
        plan.addWeek([0])
        plan.addWeek([1])
        return plan
    }
    
    static var monumental = RunningPlan(name: "Monumental Half") {
        [3, 5, 0, 4, 0, 6, 0]
        [3, 5, 0, 4, 0, 7, 0]
        [3, 5, 0, 4, 0, 6, 0]
        [3, 6, 0, 5, 0, 8, 0]
        [4, 6, 0, 5, 0, 6, 0]
        [4, 6, 0, 5, 0, 10, 0]
        [4, 6, 0, 5, 0, 8, 0]
        [4, 6, 0, 5, 0, 13, 0]
        [3, 6, 0, 4, 0, 8, 0]
        [4, 6, 0, 5, 0, 12, 0]
        [4, 6, 0, 5, 0, 10, 0]
        [4, 6, 0, 5, 0, 6, 0]
        [3, 5, 0, 4, 0, 13, 0]
    }
    
    init(name: String, @RunningPlanBuilder weeks: ()->[RunningPlanWeeklyGoal] ) {
        let weeklyGoals = weeks()
        self = RunningPlan(name: name, goals: weeklyGoals)
    }
}

extension RunningPlan: Identifiable {
    var id: String { name }
}

extension RunningPlan: Equatable {
    static func == (lhs: RunningPlan, rhs: RunningPlan) -> Bool {
        return lhs.name == rhs.name
    }
}

extension RunningPlan: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}

@resultBuilder struct RunningPlanBuilder {
    static func buildBlock(_ components: [Int]...) -> [RunningPlanWeeklyGoal] {
        return Array(components).enumerated().map { offset, element in
            var plan = RunningPlanWeeklyGoal(element)
            plan.week = offset
            return plan
        }
    }
}
