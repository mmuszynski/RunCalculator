//
//  RunningPlanController.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/27/23.
//

import SwiftUI
import OSLog

fileprivate let logger = Logger(subsystem: "com.mmuszynski.runcalculator", category: "RunningPlanController")

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

class RunningPlanController: ObservableObject {
    @Published var runningPlans: [RunningPlan] = [
        .monumental2025,
        .monumental,
        .monumentalPacer
    ]
    
    @Published var selectedPlan: RunningPlanSelection? {
        didSet {
            do {
                try saveSelectedPlan()
            } catch {
                logger.debug("Couldn't save selected plan with: \(error)")
            }
        }
    }
    
    init() {
        do {
            logger.trace("Loading selected running plan")
            try self.loadSelectedPlan()
        } catch {
            logger.debug("Couldn't load selection with: \(error)")
        }
        
        requestNotificationPermission()
    }
    
    func saveSelectedPlan() throws {
        if let selectedPlan {
            try selectedPlan.savePlanAsSelection()
        } else {
            try RunningPlanSelection.clearSavedSelection()
        }
    }
    
    func loadSelectedPlan() throws {
        self.selectedPlan = try RunningPlanSelection.loadSelectedPlan()
        reloadTodaysGoal()
        setupNotifications()
    }
    
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
    
    @Published var todaysGoal: RunningPlanDailyGoal?
    
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
        let week = plan.goals[daily.week]
        let day = week.goals[daily.day]
        
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
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge]) { granted, error in
            
            if let error = error {
                logger.debug("Couldn't get notification authorization with \(error)")
            }
            
            //was it granted?
        }
    }
    
    /// Removes all pending notifications and sets up a new set of upcoming notifications for the currently selected plan
    func setupNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        self.selectedPlan?.upcomingGoals(after: .current).forEach { goal in
            self.selectedPlan?.registerNotification(for: goal)
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            //print(requests.count)
        }
    }
    
    func reloadTodaysGoal() {
        //Gets a date two hours in the future. This should mean that the goal date is tomorrow after 10pm
        let testDate = Calendar.current.date(byAdding: .hour, value: 2, to: .current) ?? .current
        self.todaysGoal = self.selectedPlan?.goal(for: testDate)
    }
}

extension RunningPlanController {
    static var example: RunningPlanController = {
        let controller = RunningPlanController()
        controller.selectedPlan = RunningPlanSelection(startDate: Date(), plan: .monumental)
        return controller
    }()
}
