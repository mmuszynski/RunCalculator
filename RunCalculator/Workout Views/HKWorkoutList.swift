//
//  WorkoutList.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/8/23.
//

import SwiftUI
import HealthKit

extension HKWorkout: @retroactive Identifiable {}
extension DateInterval: @retroactive Identifiable {
    public var id: Date {
        self.start
    }
}

struct WorkoutList: View {
    @EnvironmentObject var hdc: HealthDataController
    @State var workouts = [HKWorkout]()
    @State var similar = Set<HKWorkout>()
    
    @State var groupedWorkouts = [DateInterval: [HKWorkout]]()
    
    func groupWorkouts() {
        guard let firstDate = self.workouts
            .map({ $0.startDate })
            .sorted()
            .first
        else {
            return
        }
      
        var month = Calendar.current.dateInterval(of: .month, for: firstDate)
        while (month?.start ?? .distantFuture) < Date() {
            guard let testMonth = month else { return }
            month = Calendar.current.dateInterval(of: .month, for: testMonth.end)
            let monthlyWorkouts = workouts.filter { testMonth.contains($0.startDate) }
            groupedWorkouts[testMonth] = monthlyWorkouts
        }
    }
    
    func testSimilarity() {
        for workout in workouts {
            for other in workouts {
                if other == workout { continue }
                if other.isSimilar(to: workout) {
                    similar.insert(workout)
                }
            }
        }
    }
    
    var sections: [DateInterval] {
        groupedWorkouts.keys.sorted().reversed()
    }
    
    func dif(from key: DateInterval) -> String {
        DateIntervalFormatter().string(from: key) ?? "???"
    }
    
    func mileageText(for array: [HKWorkout]?) -> String {
        guard let array else { return "0 miles" }
        let miles = Measurement(value: array.runkeeperMileage, unit: UnitLength.miles)
        return Formatter.mileageFormatter.string(from: miles)
    }
    
    var body: some View {
        Group {
            if sections.isEmpty {
                Text("No Workouts")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            } else {
                List(sections) { key in
                    Section {
                        ForEach(groupedWorkouts[key] ?? []) { wk in
                            HKWorkoutView(wk)
                        }
                    } header: {
                        VStack(alignment: .leading) {
                            Text(dif(from: key))
                            Text(mileageText(for: groupedWorkouts[key]))
                        }
                    }
                }
                .navigationTitle("Workouts")
            }
        }
        .task {
            self.workouts = hdc.workouts.filter {
                $0.workoutActivityType == .running
            }
            groupWorkouts()
            testSimilarity()
        }
    }
}

struct WorkoutList_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutList()
            .environmentObject(HealthDataController())
    }
}
