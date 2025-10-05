//
//  DebugView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 7/23/24.
//

import SwiftUI

struct DebugView: View {
    @EnvironmentObject var controller: HealthDataController
    @Environment(MileageGoalController.self) var goalController
    
    var body: some View {
        List {
            Section {
                Button("Reset Caches") {
                    Task {
                        await controller.loadWorkouts(usingCache: false)
                    }
                }
            } header: {
                Text("Run data (\(controller.workouts.count) workouts)")
                    .foregroundStyle(.secondary)
            } footer: {
                if let cacheDate = controller.lastCachedAt {
                    Text("Last cached at \(cacheDate, format: .dateTime)")
                } else {
                    Text("Never cached")
                }
            }
            
            Section {
                Button("Remove All Goals") {
                    goalController.goals.removeAll()
                    try! goalController.save()
                }
            }

        }
    }
}

#Preview {
    DebugView()
        .environmentObject(HealthDataController())
        .environment(MileageGoalController())
}
