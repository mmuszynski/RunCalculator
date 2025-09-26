//
//  MileageGoalViewController.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 7/27/24.
//

import Foundation
import HealthKit

@Observable
class MileageGoalViewController {
    var hdc: HealthDataController
    var goal: MileageGoal
    
    init(hdc: HealthDataController, goal: MileageGoal) {
        self.hdc = hdc
        self.goal = goal
    }
    
    var mileageFormatter: MeasurementFormatter {
        .mileageFormatter(minimumFractionDigits: 1, maximumFractionDigits: 1)
    }
    
    var mileageTowardsGoal: Measurement<UnitLength> {
        let start = goal.interval.start
        let end = min(goal.interval.end, .current)
        let interval = DateInterval(start: start, end: end)
        
        return hdc.runkeeperMileage(for: interval).miles
    }
    
    var goalMileageRemaining: Measurement<UnitLength> {
        let current = mileageTowardsGoal
        let goal = goal.measurement
        return goal - current
    }
    
    func componentDuration(for calendarComponent: Calendar.Component) -> TimeInterval {
        //get a presumptive length of the component
        Calendar.current.dateInterval(of: calendarComponent, for: .current)!.duration
    }
    
    func goalMileageRate(per calendarComponent: Calendar.Component) -> Measurement<UnitLength> {
        let target = goal.measurement
        
        //figure out how many component lengths fit in the goal interval length
        let goalIntervalDuration = goal.interval.duration
        let numDurations = goalIntervalDuration / componentDuration(for: calendarComponent)
        
        let averageMileageRate = target.value / numDurations
        return Measurement(value: averageMileageRate, unit: target.unit)
    }
    
    var timeRemaining: Int {
        let interval = goal.interval
        var currentInterval = interval
        currentInterval.end = .current
        
        let goalIntervalDuration = interval.duration
        let currentIntervalDuration = currentInterval.duration
        let secondsRemaining = goalIntervalDuration - currentIntervalDuration
        
        let secondsInWeek = 60 * 60 * 24 * 7.0
        
        return Int(secondsRemaining / secondsInWeek)
    }
    
    func remainingMileageRate(per calendarComponent: Calendar.Component) -> Measurement<UnitLength> {
        let target = goalMileageRemaining
        
        //figure out how many component lengths fit in the goal interval length
        let interval = goal.interval
        var currentInterval = interval
        currentInterval.end = .current
        
        let goalIntervalDuration = interval.duration
        let currentIntervalDuration = currentInterval.duration
        let durationRemaining = goalIntervalDuration - currentIntervalDuration
        
        if durationRemaining < 0 {
            return Measurement(value: .zero, unit: target.unit)
        }
        
        let numDurations = durationRemaining / componentDuration(for: calendarComponent)
        
        let averageMileageRate = target.value / numDurations
        return Measurement(value: averageMileageRate, unit: target.unit)
    }
    
    var mileageAgainstPace: Measurement<UnitLength> {
        let interval = goal.interval
        var currentInterval = interval
        currentInterval.end = .current
        
        let intervalFractionComplete = currentInterval.duration / interval.duration
        
        let distance: Measurement<UnitLength>
        if intervalFractionComplete >= 1 {
            distance = hdc.runkeeperMileage(for: interval).miles
        } else {
            distance = hdc.runkeeperMileage(for: currentInterval).miles
        }
        
        let pace = goal.measurement * min(intervalFractionComplete, 1)
        return pace - distance
    }
    
    var workoutsDuringInterval: [HKWorkout] {
        hdc.workouts.runkeeperWorkouts.filter { goal.interval.contains($0.startDate) }
    }
}
