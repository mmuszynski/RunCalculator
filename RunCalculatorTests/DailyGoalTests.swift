//
//  DailyGoalTests.swift
//  RunCalculatorTests
//
//  Created by Mike Muszynski on 8/3/23.
//

import XCTest
@testable import RunCalculator

final class DailyGoalTests: XCTestCase {
    
    func testExample() throws {
        let plan = RunningPlan.monumental
        let selection = RunningPlanSelection(startDate: Date.current, plan: .monumental)
        let day = selection.dateInterval(for: plan.allDailyGoals.first!)        
        
    }

}
