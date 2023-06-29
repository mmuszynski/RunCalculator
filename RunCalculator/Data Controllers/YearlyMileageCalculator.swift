//
//  YearlyMileageCalculator.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/3/23.
//

import Foundation
import SwiftUI
import HealthKit

class YearlyMileageCalculator: ObservableObject {
    
    @AppStorage("com.mmuszynski.runCalculator.mileageAsOfToday") var mileageAsOfToday: Double = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    @Published var mileageGoal: Double = 500
    private var workouts: [HKWorkout] = []
    
    func setWorkouts(_ workouts: [HKWorkout]) {
        self.workouts = workouts.filter({ wk in
            wk.startDate.startOfYear == Date().startOfYear
        })
        self.mileageAsOfToday = self.workouts.runkeeperMileage
    }
    
    /// The time period for the average
    enum MileageTimeframe: String, CaseIterable {
        case day, week, month
        
        var pluralDescription: String {
            return self.rawValue + "s"
        }
    }
    
    /// The component used to calculate the average mileage remaining
    @Published var mileageTimeframe: MileageTimeframe = .week
    
    func nextTimeframe() {
        guard let index = MileageTimeframe.allCases.firstIndex(of: mileageTimeframe)?.advanced(by: 1),
              index < MileageTimeframe.allCases.endIndex
        else {
            mileageTimeframe = .day
            return
        }
        mileageTimeframe = MileageTimeframe.allCases[index]
    }
    
    var remainingTimeframeDescription: String {
        switch mileageTimeframe {
        case .day:
            return "\(daysRemainingInCurrentYear) days"
        case .month:
            return "\(monthsRemainingInCurrentYear) months"
        case .week:
            return "\(Date.weeksRemainingInCurrentYear) weeks"
        }
    }
    
    /// Adjusts the mileage by a certain amount
    /// - Parameter amount: The amount to adjust today's mileage, up or down
    func fineTune(_ amount: Double) {
        mileageAsOfToday = mileageAsOfToday + amount
    }
    
    /// The ordinal day of the year for the current date
    var currentDayOfYear: Int {
        return Date().dayOfYear!
    }
    
    /// The number of days in the current year
    var daysInCurrentYear: Int {
        return Date().daysInYear!
    }
    
    /// The number of days remaining in the current year, including the current day
    var daysRemainingInCurrentYear: Int {
        daysInCurrentYear - currentDayOfYear + 1
    }
    
    var mileageRateAsOfToday: Double {
        mileageAsOfToday / Double(currentDayOfYear)
    }
    
    var mileageRemainingAsOfToday: Double {
        mileageGoal - mileageAsOfToday
    }
    
    var monthsRemainingInCurrentYear: Int {
        13 - Date().monthOfYear!
    }
    
    var mileageRatePerWeekToCompleteGoal: Double {
        mileageRemainingAsOfToday / Double(Date.weeksRemainingInCurrentYear)
    }
    
    private func totalMileageRate(for timePeriod: MileageTimeframe) -> Double {
        switch timePeriod {
        case .day:
            return mileageGoal / Double(daysInCurrentYear)
        case .month:
            return mileageGoal / Double(12)
        case .week:
            return mileageGoal / 52
        }
    }
    
    private func mileageRateToCompleteGoal(for timePeriod: MileageTimeframe) -> Double {
        switch timePeriod {
        case .day:
            return mileageRemainingAsOfToday / Double(daysRemainingInCurrentYear)
        case .week:
            return mileageRemainingAsOfToday / Double(Date.weeksRemainingInCurrentYear)
        case .month:
            return mileageRemainingAsOfToday / Double(monthsRemainingInCurrentYear)
        }
    }
    
    var requiredMileageRate: Double {
        mileageRateToCompleteGoal(for: self.mileageTimeframe)
    }
    
    var completeMileageRate: Double {
        totalMileageRate(for: self.mileageTimeframe)
    }
    
    func mileage(for dateRange: Range<Date>) async -> Double {
        let workouts = self.workouts.filter {
            dateRange.contains($0.startDate)
        }
        return workouts.runkeeperMileage
    }
}

extension Array where Element == HKWorkout {
    var runkeeperMileage: Double {
        let workouts = self.filter {
            $0.workoutActivityType == .running &&
            $0.sourceRevision.source.name == "Runkeeper"
        }
        
        let miles = workouts.cumulativeDistance.doubleValue(for: .mile())
        return miles
    }
    
    var runMileage: Double {
        let workouts = self.filter {
            $0.workoutActivityType == .running
        }
        
        return workouts.mileage
    }
    
    var mileage: Double {
        let miles = self.cumulativeDistance.doubleValue(for: .mile())
        return miles
    }
}
