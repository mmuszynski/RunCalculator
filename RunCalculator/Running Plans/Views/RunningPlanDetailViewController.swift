//
//  RunningPlanDetailViewController.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 7/5/23.
//

import Foundation

class RunningPlanDetailViewController: ObservableObject {
    var plan: RunningPlan
    
    @Published var startDate: Date = .current
    var endDate: Date {
        get {
            Calendar.current.date(byAdding: .day, value: 7 * plan.weeks, to: startDate)!
        }
        set {
            self.startDate = Calendar.current.date(byAdding: .day, value: -7 * plan.weeks, to: newValue)!
            objectWillChange.send()
        }
    }
    
    init(plan: RunningPlan, startDate: Date = .current) {
        self.plan = plan
        self.startDate = startDate
    }
}
