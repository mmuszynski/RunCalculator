//
//  RunningPlanSelection.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 7/29/23.
//

import Foundation
import UserNotifications
import OSLog

fileprivate let logger = Logger(subsystem: "com.mmuszynski.runcalculator", category: "RunningPlanSelection")
let notificationLogger = Logger(subsystem: "com.mmuszynski.runcalculator", category: "NotificationSubsystem")

extension DateInterval {
    static func starting(with date: Date, advancingStartBy startDays: Int = 0, advancingEndBy endDays: Int = 0) -> DateInterval {
        precondition(endDays >= 0, "The end of the DateInterval must be advanced by a positive number of days")
        var interval = Calendar.current.dateInterval(of: .day, for: date)!
        interval.start = Calendar.current.date(byAdding: .day, value: startDays, to: interval.start)!
        if endDays == .max {
            interval.end = .distantFuture
        } else {
            interval.end = Calendar.current.date(byAdding: .day, value: endDays, to: interval.start)!
        }
        return interval
    }
}

struct RunningPlanSelection: Codable {
    var startDate: Date
    var plan: RunningPlan
    
    static func saveLocation() throws -> Persistence.Location {
        let url = URL.applicationSupportDirectory.appending(components: "com.mmuszynski.runcalculator", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        let location = Persistence.Location(url: url)
        return location
    }
    
    static func clearSavedSelection() throws {
        let location = try RunningPlanSelection.saveLocation()
        try FileManager.default.removeItem(at: location.url.appending(component: "selectedPlan"))
    }
    
    static func loadSelectedPlan() throws -> RunningPlanSelection {
        let location = try RunningPlanSelection.saveLocation()
        let plan = try Persistence.read(RunningPlanSelection.self, from: location, withFilename: "selectedPlan")
        return plan
    }
    
    func savePlanAsSelection() throws {
        let location = try RunningPlanSelection.saveLocation()
        try Persistence.write(self, to: location, withFilename: "selectedPlan")
    }
    
    func goal(for date: Date) -> RunningPlanDailyGoal? {
        let goal = plan.allDailyGoals.first { goal in
            goal.dateInterval(startingPlanOn: self.startDate)?.contains(date) == true
        }
        
        return goal
    }
    
    func dateInterval(for goal: RunningPlanDailyGoal) -> DateInterval? {
        guard let goalDate = Calendar.current.date(byAdding: .day, value: goal.week * 7 + goal.day, to: startDate) else {
            return nil
        }
        return Calendar.current.dateInterval(of: .day, for: goalDate)
    }
    
    
    /// Calculates the goals that will occur in a certain Date Interval.
    ///
    /// Since `RunningPlanDailyGoal` objects have generically described dates, some caluclation must be done to translate them to dates (see `dateInterval(for:)`). This method is useful for doing that calculation on a number of goal objects in order to filter out the objects that do not begin in a certain timeframe.
    ///
    /// The method creates a `DateInterval` by querying the current calendar for the interval that represnts the full day of the given `Date`. The end of this interval is then advanced by the number of days supplied. The value of days must be greater than or equal to zero.
    ///
    /// - Parameters:
    ///   - date: The date at which the `DateInterval` should start
    ///   - days: The number of days to expand the `DateInterval`. Must not be negative.
    /// - Returns: Any `RunningPlanDailyGoal` objects that start within the `DateInterval`
    func upcomingGoals(after date: Date, days: Int = .max) -> [RunningPlanDailyGoal] {
        let interval = DateInterval.starting(with: date, advancingStartBy: 1, advancingEndBy: days)

        return plan.allDailyGoals.filter { goal in
            let goalInterval = dateInterval(for: goal)!
            
            if interval.contains(goalInterval.start) {
                return true
            }
            return false
        }
    }
    
    func registerNotification(for goal: RunningPlanDailyGoal) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Run"
        if goal.miles > 0 {
            content.body = "You have a \(Formatter.mileageFormatter.string(from: goal.mileageMeasurement)) run scheduled for tomorrow."
        } else {
            return
        }
        
        guard let start = dateInterval(for: goal)?.start,
              let notificationTime = Calendar.current.date(byAdding: .hour, value: -2, to: start) else {
            print("Couldn't get notification time for \(goal)")
            return
        }
        
        let components = Calendar.current.dateComponents([.hour, .day, .month], from: notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        if let date = trigger.nextTriggerDate() {
            let time = DateFormatter()
            time.dateStyle = .short
            time.timeStyle = .medium
            
            notificationLogger.debug("Scheduled notification for \(time.string(for: date) ?? "Unknown time")")
            
            let interval = date.timeIntervalSinceNow
            notificationLogger.debug("This is \(interval / 60) minutes (or \(interval / 3600) hours) from now")
        } else {
            notificationLogger.debug("Couldn't get next notification date. The notification will probably not be successful.")
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Error adding notification request: \(error)")
            }
        }
    }
}
