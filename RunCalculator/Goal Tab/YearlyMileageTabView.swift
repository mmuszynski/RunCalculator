//
//  YearlyMileagePieChart.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/22/23.
//

import SwiftUI

struct YearlyMileageTabView: View {
    @EnvironmentObject var hdc: HealthDataController
    @EnvironmentObject var planController: RunningPlanController
    
    @State private var hideGoal: Bool = false
    @Environment(MileageGoalController.self) var goalController
    
    var body: some View {
        ZStack {
            GeometryReader { g in
                VStack {
                    TodaysRunView(goal: planController.todaysGoal)
                        .contentShape(Rectangle())
                    Spacer()
                }
                .zIndex(1)
                .offset(x: hideGoal ? -g.size.width * 0.8 : 0)
                .padding()
            }
            
            TabView {
                ForEach(goalController.goals) { goal in
                    VStack(alignment: .leading) {
                        Spacer()
                        Group {
                            Text("Goal: ") +
                            Text(goal.measurement, formatter: .mileageFormatter)
                        }
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .padding(.leading)
                        
                        Text(goal.interval, formatter: DateIntervalFormatter(timeStyle: .none, dateStyle: .short))
                            .padding(.leading)
                        
                        MileagePieChart()
                            .aspectRatio(contentMode: .fit)
                            .padding()
                            .environment(MileageGoalViewController(hdc: hdc, goal: goal))
                        Spacer()
                    }
                }
                NewMileageGoalView()
            }
            .tabViewStyle(.page)
        }
        .task {
            planController.reloadTodaysGoal()
            if planController.todaysGoal != nil {
                hdc.resetCaches()
            }
            await hdc.loadWorkouts()
            planController.reloadTodaysGoal()
        }
    }
}

#Preview {
    YearlyMileageTabView()
        .environmentObject(HealthDataController())
        .environmentObject(RunningPlanController())
        .environment(MileageGoalController())
}
