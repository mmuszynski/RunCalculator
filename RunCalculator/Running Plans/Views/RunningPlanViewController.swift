//
//  RunningPlanViewController.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/27/23.
//

import SwiftUI

extension String {
    fileprivate var sanitizeDecimal: String {
        let comps = self.components(separatedBy: ".")
        var stripped = comps[0]
        for (index, comp) in comps.enumerated() {
            if index == 0 { continue }
            else if index == 1 { stripped += "." }
            stripped += comp
        }
        return stripped
    }
}

class RunningPlanViewController: ObservableObject {
    @Published var runningPlans: [RunningPlan] = [.monumental]
    
    func addPlan() {
        var proposedName = "New Plan"
        var num = 0
        while runningPlans.contains(where: { $0.name == proposedName }) {
            num += 1
            proposedName = "New Plan \(num)"
        }
        
        self.runningPlans.append(RunningPlan(name: proposedName))
        self.objectWillChange.send()
    }
    
    @Published var plan: RunningPlan = .monumental
    @Published var selection: RunningPlanDailyGoal? {
        didSet {
            guard let newString = selection?.miles.adaptivePrecisionString else {
                editString = ""
                return
            }
            if newString + "." == editString {
                return
            } else {
                editString = newString
            }
        }
    }
    
    /// A string representing the mileage that is being edited
    ///
    /// When a daily goal is selected, this  string will hold a textual representation of the mileage for that goal
    /// When the selection becomes nil, the string will also become nil
    @Published var editString: String = "" {
        didSet {
            if editString.sanitizeDecimal != editString {
                editString = editString.sanitizeDecimal
            }

            keypress(nil)
        }
    }
    
    /// Sets the selected goal to the number of miles provided
    /// - Parameters:
    ///   - daily: The selected daily running plan goal.
    ///   - amount: The amount to set the mileage to.
    func setSelectedGoal(_ daily: RunningPlanDailyGoal?, to amount: Double) {
        guard let daily = daily else { return }
        var week = plan.goals[daily.week]
        var day = week.goals[daily.day]
        
        day.miles = amount
        if day.miles < 0 { day.miles = 0 }
        week.goals[daily.day] = day
        plan.goals[daily.week] = week
        
        //self.selection = day
    }
    
    /// Increases the mileage for the provided daily running goal
    /// - Parameters:
    ///   - daily: The goal whose amount needs to be increased
    ///   - amount: The amount to increase (or decrease, given a negative value)
    func increase(_ daily: RunningPlanDailyGoal?, by amount: Double) {
        self.setSelectedGoal(daily, to: daily?.miles ?? 0 + amount)
    }
    
    /// Controls the amount based on the custom keyboard
    /// - Parameter key: The character of the key that was pressed
    func keypress(_ key: Character?) {
        if let key {
            let keyString = String(key)
            switch keyString {
            case "⌫":
                editString = String(editString.dropLast())
            case ".":
                //if there already is a period, do nothing, otherwise fallthrough
                if editString.contains(where: { $0 == ".".first! }) == true { return }
                fallthrough
            default:
                editString = editString + keyString
            }
        }
        
        if let miles = NumberFormatter().number(from: editString) as? Double {
            self.setSelectedGoal(selection, to: miles)
        } else if editString == "" {
            self.setSelectedGoal(selection, to: 0)
        } else {
            print("Couldn't get number from string")
        }
    }
}
