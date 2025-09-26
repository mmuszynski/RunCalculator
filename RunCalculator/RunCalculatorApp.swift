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
    let healthDataController = HealthDataController()
    let planController = RunningPlanController()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(healthDataController)
                .environmentObject(planController)
        }
    }
}

struct TabLabel: ViewModifier {
    var imageName: String
    var text: String
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                VStack {
                    Image(systemName: imageName)
                    Text(text)
                }
            }
    }
}

extension View {
    func tabLabel(_ text: String, image imageName: String) -> some View {
        modifier(TabLabel(imageName: imageName, text: text))
    }
}

struct MainView: View {
    @EnvironmentObject var healthDataController: HealthDataController
    @EnvironmentObject var planController: RunningPlanController
    @State var mileageGoalController: MileageGoalController = MileageGoalController()
    
    var body: some View {
        TabView {
            YearlyMileageTabView()
                .tabLabel("Progress",
                          image: "figure.run")
            MileageChart()
                .tabLabel("Chart",
                          image: "chart.line.uptrend.xyaxis")
            WorkoutList()
                .tabLabel("Workouts",
                          image: "calendar")
            RunningPlanNavigationView()
                .tabLabel("Plan",
                          image: "calendar.badge.plus")
            DebugView()
                .tabLabel("Debug",
                          image: "gear")
        }
        .environment(mileageGoalController)
    }
}

#Preview {
    MainView()
        .environmentObject(HealthDataController())
        .environmentObject(RunningPlanController())
}
