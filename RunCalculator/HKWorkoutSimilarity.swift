//
//  HKWorkoutSimilarity.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/19/23.
//

import Foundation
import HealthKit

extension HKWorkout {
    var runningDistance: HKQuantity? {
        let distanceType = HKQuantityType(.distanceWalkingRunning)
        return self.allStatistics[distanceType]?.sumQuantity()
    }
    
    func isSimilar(to other: HKWorkout) -> Bool {
        guard let distance = self.runningDistance?.doubleValue(for: .mile()),
              let otherDistance = other.runningDistance?.doubleValue(for: .mile())
        else {
            return false
        }
        
        //are they on the same day?
        let date = Calendar.current.dateComponents([.day, .month, .year], from: self.startDate)
        let otherDate = Calendar.current.dateComponents([.day, .month, .year], from: other.startDate)
        
        //do they have similar distances
        let distancesAreClose = fabs(distance - otherDistance) / (distance + otherDistance) < 0.05
        
        return date == otherDate && distancesAreClose
    }
}

extension Array where Element == HKWorkout {
    var uniqueWorkouts: Self {
        var returnArray = Array<HKWorkout>()
        
        for workout in self {
            if returnArray.first(where: { theWorkout in
                theWorkout.isSimilar(to: workout)
            }) == nil {
                returnArray.append(workout)
            }
        }
        return returnArray
    }
}
