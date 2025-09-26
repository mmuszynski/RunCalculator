//
//  GoalSelectionViewController.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/8/24.
//

import SwiftUI

@Observable
class MileageGoalController {
    var selection: MileageGoal.ID? = nil
    var goals: [MileageGoal] = []
    
    static var saveLocation: Persistence.Location {
        get throws {
            let url = URL.applicationSupportDirectory.appending(components: "com.mmuszynski.runcalculator", directoryHint: .isDirectory)
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            let location = Persistence.Location(url: url)
            return location
        }
    }
    
    init() {
        do {
            try self.load()
        } catch {
            goals = []
        }
    }
    
    func save() throws {
        try Persistence.write(self.goals, to: try MileageGoalController.saveLocation, withFilename: "mileageGoals.plist")
    }
    
    func load() throws {
        self.goals = try Persistence.read(Array<MileageGoal>.self, from: MileageGoalController.saveLocation, withFilename: "mileageGoals.plist")
        self.sort()
    }
    
    func append(_ goal: MileageGoal) {
        self.goals.append(goal)
        self.sort()
        do {
            try self.save()
        } catch {
            print("Error saving: \(error)")
        }
    }
    
    func sort() {
        goals = goals.sorted(by: { one, two in
            if one.isCurrent {
                if two.isCurrent {
                    return two.interval.start < one.interval.start
                } else {
                    return true
                }
            } else if one.isUpcoming {
                if two.isUpcoming {
                    return two.interval.start < one.interval.start
                } else if two.isExpired {
                    return true
                } else {
                    return false
                }
            }
            
            if two.interval == one.interval {
                return one.target.miles < two.target.miles
            }
            
            return two.interval.start < one.interval.start
        })
    }
}

extension MileageGoalController {
    class var example: MileageGoalController {
        let controller = MileageGoalController()
        controller.goals.append(MileageGoal())
        controller.goals.append(MileageGoal(kilometers: 1000))
        controller.selection = controller.goals.first?.id
        return controller
    }
}
