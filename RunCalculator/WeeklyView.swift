//
//  WeeklyView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 4/27/23.
//

import SwiftUI

class DateIntervalDisplayObject: Identifiable {
    var id: UUID
    var interval: DateInterval
    
    init(_ interval: DateInterval) {
        self.id = UUID()
        self.interval = interval
    }
}

struct WeeklyView: View {
    @EnvironmentObject var dataController: HealthDataController
    var days: [Date] {
        var returnValue: [Date] = []
        
        var current = DateComponents(calendar: .current, year: 2001).date!.startOfYear!
        let lastDay = current.endOfYear!
        while current.compare(lastDay) == .orderedAscending {
            returnValue.append(current)
            current = Calendar.current.date(byAdding: .day, value: 1, to: current)!
        }
        
        return returnValue
    }
    
    var weeks: [DateIntervalDisplayObject] {
        let current = Date().startOfYear!
        return current.weekIntervals.map { interval in
            return DateIntervalDisplayObject(interval)
        }
    }
    
    var dayNameFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "cccc"
        return df
    }()
    
    var shortDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .long
        return df
    }()
    
    var body: some View {
        NavigationView {
            List(weeks) { obj in
                let weekActivity = dataController.workouts.filter({ workout in
                    obj.interval.contains(workout.startDate)
                })
                let weekRuns = weekActivity.filter {
                    $0.workoutActivityType == .running
                }
                let mileage = weekRuns.reduce(0.0) { partialResult, workout in
                    partialResult + (workout.runningDistance?.doubleValue(for: .mile()) ?? 0)
                }
                
                NavigationLink {
                    WorkoutList(workouts: weekActivity)
                } label: {
                    VStack(alignment: .leading) {
                        Text(obj.interval, formatter: DateIntervalFormatter.longDate)
                        Text("\(weekRuns.count) runs: (\(mileage, specifier: "%0.1f") mi)")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Weeks")
            .task {
                await dataController.loadWorkouts()
            }
        }
    }
}

struct WeeklyView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyView()
            .environmentObject(HealthDataController())
    }
}
