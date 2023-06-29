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
    let planController = RunningPlanViewController()
    
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
    @EnvironmentObject var planController: RunningPlanViewController
    
    
    
    var body: some View {
        TabView {
            YearlyMileagePieChart()
                .tabLabel("Progress",
                          image: "figure.run")
            MileageChart()
                .tabLabel("Chart",
                          image: "chart.line.uptrend.xyaxis")
            CalendarView()
                .tabLabel("Workouts",
                          image: "calendar")
            RunningPlanNavigationView()
                .tabLabel("Plan",
                          image: "calendar.badge.plus")
        }
    }
}

#Preview {
    MainView()
        .environmentObject(HealthDataController())
        .environmentObject(RunningPlanViewController())
}
