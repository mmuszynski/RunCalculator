//
//  WorkoutPeriodSummary.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/12/23.
//

import Foundation
import HealthKit

struct WorkoutPeriodSummary {
    enum PeriodLength {
        case year, month, week, day
    }
    
    var interval: DateInterval = Calendar.current.dateInterval(of: .year, for: .current)!
    var workouts: [HKWorkout] = [] {
        didSet {
            self.runningDistance = Measurement(value: workouts.runkeeperMileage, unit: .miles)
//            self.runningDistance = workouts.reduce(Measurement(value: 0, unit: .miles)) { partialResult, nextWorkout in
//                var value = partialResult.value
//                value += nextWorkout.runningDistance?.doubleValue(for: .mile()) ?? 0
//
//                return Measurement(value: value, unit: .miles)
//            }
        }
    }
    private var periodLength: PeriodLength = .year
    
    var runningDistance: Measurement<UnitLength> = Measurement(value: 0, unit: .miles)
    
    init(year: Int) {
        let date = Calendar.current.date(from: DateComponents(year: year))!
        let range = Calendar.current.dateInterval(of: .year, for: date)!
        self.interval = range
    }
    
    init(monthFor date: Date) {
        let range = Calendar.current.dateInterval(of: .month, for: date)!
        self.interval = range
        self.periodLength = .month
    }
    
    init(weekFor date: Date) {
        let range = Calendar.current.dateInterval(of: .weekOfYear, for: date)!
        self.interval = range
        self.periodLength = .week
    }
    
    init() {}
}

extension WorkoutPeriodSummary: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(interval)
    }
}

extension WorkoutPeriodSummary {
    static var example: Self {
        return WorkoutPeriodSummary()
    }
}

struct WorkoutPeriodSummaryCache {
    var expiry: Date = Date.current.addingTimeInterval(300)
    var summary: WorkoutPeriodSummary
}
