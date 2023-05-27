//
//  WorkoutList.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/8/23.
//

import SwiftUI
import HealthKit

extension HKWorkout: Identifiable {}

struct WorkoutList: View {
    var workouts = [HKWorkout]()
    @State var similar = Set<HKWorkout>()
    
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
    
    var body: some View {
        if self.workouts.isEmpty {
            Text("No Workouts")
                .font(.largeTitle)
                .foregroundColor(.gray)
        } else {
            List(self.workouts) { workout in
                HStack {
                    HKWorkoutView(workout)
                    if similar.contains(workout) {
                        Image(systemName:
                                "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                    }
                }
            }
            .navigationTitle("Workouts")
            .onAppear {
                testSimilarity()
            }
        }
            
    }
}

struct WorkoutList_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutList()
            .environmentObject(HealthDataController())
    }
}
