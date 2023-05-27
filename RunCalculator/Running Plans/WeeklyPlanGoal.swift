//
//  WeeklyPlanGoal.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/6/23.
//

import Foundation

struct WeeklyPlanGoal: Codable {
    var dateInterval: DateInterval
    var plannedMileage: Double {
        get {
            return dailyGoals.reduce(0) { partialResult, goal in
                partialResult + goal.plannedMileage
            }
        }
        set {
            var weekday = self.dateInterval.start
            var days = [Date]()
            while self.dateInterval.contains(weekday) && weekday != self.dateInterval.end {
                days.append(weekday)
                weekday = Calendar.current.date(byAdding: .day, value: 1, to: weekday)!
            }
            let amount = newValue / Double(self.dailyGoals.count)
            self.dailyGoals = days.map { DailyPlanGoal(for: $0, mileage: amount) }
        }
    }
    var plannedMileageMeasurement: Measurement<UnitLength> {
        Measurement(value: plannedMileage, unit: .miles)
    }
    
    var dailyGoals: [DailyPlanGoal] = []
    
    init(dateInterval: DateInterval, plannedMileage: Double) {
        self.dateInterval = dateInterval
        self.plannedMileage = plannedMileage
    }
}

extension WeeklyPlanGoal: Hashable, Equatable {
    static func == (lhs: WeeklyPlanGoal, rhs: WeeklyPlanGoal) -> Bool {
        lhs.dateInterval == rhs.dateInterval
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(dateInterval)
    }
}

struct DailyPlanGoal: Codable {
    var dateInterval: DateInterval
    var plannedMileage: Double
    
    init(for date: Date, mileage: Double = 0) {
        self.dateInterval = Calendar.current.dateInterval(of: .day, for: date)!
        self.plannedMileage = mileage
    }
}
