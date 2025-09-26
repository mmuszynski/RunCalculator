//
//  RunningPlanDailyGoal.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/25/23.
//

import Foundation

class RunningPlanDailyGoal: Codable {
    var miles: Double
    var day: Int
    var week: Int
    
    var mileageMeasurement: Measurement<UnitLength> {
        return Measurement(value: miles, unit: .miles)
    }
    
    init(miles: Double, day: Int, week: Int) {
        self.miles = miles
        self.day = day
        self.week = week
    }
    
    func dateInterval(startingPlanOn startDate: Date) -> DateInterval? {
        guard let date = Calendar.current.date(byAdding: .day, value: self.day + self.week * 7, to: startDate) else { return nil }
        return Calendar.current.dateInterval(of: .day, for: date)
    }
}

extension RunningPlanDailyGoal: Identifiable {
    var id: String {
        String(describing: day) + String(describing: week)
    }
}

extension RunningPlanDailyGoal: Equatable {
    static func == (lhs: RunningPlanDailyGoal, rhs: RunningPlanDailyGoal) -> Bool {
        lhs.miles == rhs.miles && lhs.day == rhs.day && lhs.week == rhs.week
    }
}

extension RunningPlanDailyGoal: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(miles)
        hasher.combine(day)
        hasher.combine(week)
    }
}
