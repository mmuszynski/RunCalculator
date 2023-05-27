//
//  RunningPlanCalculator.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/6/23.
//

import Foundation

extension Persistence.Location {
    fileprivate static var planLocaton = try! Persistence.Location.bundleSpecificUserApplicationSupport().appending(pathComponent: "savedRunPlan")
}

class RunningPlanController {
    var healthDataController: HealthDataController
    var plan: RunningPlan
    
    init() {
        healthDataController = HealthDataController()
        plan = RunningPlan()
    }
    
    func loadSavedPlan() throws {
        self.plan = try RunningPlan.load(from: .planLocaton)
    }
    
    func savePlan() {
        
    }
}
