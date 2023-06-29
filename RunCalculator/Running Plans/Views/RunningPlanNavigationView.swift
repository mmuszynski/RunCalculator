//
//  RunningPlanNavigationView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/29/23.
//

import SwiftUI

struct RunningPlanNavigationView: View {
    @EnvironmentObject var viewController: RunningPlanViewController
    
    var body: some View {
        NavigationStack {
            List(viewController.runningPlans) { plan in
                NavigationLink(plan.name, value: plan)
            }
            .navigationDestination(for: RunningPlan.self) { plan in
                RunningPlanView(plan: .constant(plan))
            }
            .overlay {
                Text("No plans.")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .opacity(viewController.runningPlans.isEmpty ? 0.25 : 0)
            }
            .navigationTitle("Running Plans")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button(action: {
                        withAnimation {
                            viewController.addPlan()
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    RunningPlanNavigationView()
        .environmentObject(RunningPlanViewController())
}
