//
//  YearlyMileageListView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 9/26/25.
//


import SwiftUI
import OSLog

fileprivate let logger = Logger(subsystem: "com.mmuszynski.RunCalculator", category: "YearlyMileageListView")

struct YearlyMileageListView: View {
    @EnvironmentObject var hdc: HealthDataController
    @EnvironmentObject var planController: RunningPlanController
    
    @State private var hideGoal: Bool = false
    @Environment(MileageGoalController.self) var goalController
    
    //For state restoration
    @StateObject private var pathObject: NavigationPathObject = NavigationPathObject()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        @Bindable var goalController = goalController
        ZStack {
            GeometryReader { g in
                VStack {
                    Spacer()
                    TodaysRunView(goal: planController.todaysGoal, isShowing: !hideGoal)
                        .contentShape(Rectangle())
                        .offset(x: hideGoal ? g.size.width * 0.85 : 0)
                        .onTapGesture {
                            withAnimation {
                                hideGoal.toggle()
                            }
                        }
                        .padding()
                }
            }
            .zIndex(1)
        
            NavigationStack(path: $pathObject.path) {
                List {
                    Section {
                        ForEach($goalController.goals, editActions: .delete) { $goal in
                            NavigationLink(value: goal) {
                                YearlyMileageListElement(goal: goal)
                            }
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(value: "New") {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationTitle("Running Goals")
                .navigationDestination(for: MileageGoal.self) { goal in
                    MileagePieChartView(goal: goal)
                }
                .navigationDestination(for: String.self) { _ in
                    NewMileageGoalView()
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .task {
            planController.reloadTodaysGoal()
            if planController.todaysGoal != nil {
                hdc.resetCaches()
            }
            await hdc.loadWorkouts()
            planController.reloadTodaysGoal()
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                pathObject.save()
            }
        }
        .onChange(of: goalController.goals) { _, _ in
            do {
                try goalController.save()
            } catch {
                logger.debug("Error saving goals")
            }
        }
    }
}

struct YearlyMileageListElement: View {
    @EnvironmentObject var hdc: HealthDataController
    var goal: MileageGoal
    var vc: MileageGoalViewController {
        MileageGoalViewController(hdc: hdc, goal: goal)
    }
    
    var body: some View {
        HStack {
            MileagePieChart(style: .minimal)
                .aspectRatio(contentMode: .fit)
                .environment(MileageGoalViewController(hdc: hdc, goal: goal))
                .frame(maxHeight: 40)
            
            VStack(alignment: .leading) {
                Text(goal.interval, formatter: DateIntervalFormatter(timeStyle: .none, dateStyle: .medium))
                    .font(.headline)
                Group {
                    Text("\(vc.mileageTowardsGoal.value, format: .number.precision(.fractionLength(1))) / \(goal.measurement, formatter: .mileageFormatter)")
                }
                .font(.title3)
            }
        }
    }
}

#Preview {
    ZStack {
        YearlyMileageListView()
            .environmentObject(HealthDataController())
            .environmentObject(RunningPlanController.example)
            .environment(MileageGoalController())
        Text(Date.current, format: .dateTime)
    }
    .onAppear {
        DateGenerator.currentDateGenerator = {
            Date().addingTimeInterval(60*60*24)
        }
    }
}
