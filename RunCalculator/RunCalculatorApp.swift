//
//  RunCalculatorApp.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/3/23.
//

import SwiftUI

extension Color {
    static var random: Color {
        Color(hue: .random(in: 0...1), saturation: .random(in: 0...1), brightness: 1)
    }
}

@main
struct RunCalculatorApp: App {
    let controller = HealthDataController()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                VStack {
                    YearlyMileageCalculatorView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.gray)
                    HKWorkoutSummaryGrid()
                        .frame(height: 180)
                }
                .tabItem { Text("Current") }
                MileageChart()
                    .tabItem { Text("Chart") }
                WeeklyView()
                    .tabItem { Text("Weeks") }
                RunningPlanView(plan: RunningPlan())
                    .tabItem { Text("Plan") }
            }
            .environmentObject(controller)
        }
    }
}
