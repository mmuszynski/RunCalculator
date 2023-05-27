//
//  RunningPlanDailyGoal.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/25/23.
//

import Foundation

struct RunningPlanDailyGoal: Codable, Hashable {
    var miles: Double
    var day: Int
    var week: Int
    
    var mileageMeasurement: Measurement<UnitLength> {
        return Measurement(value: miles, unit: .miles)
    }
}
