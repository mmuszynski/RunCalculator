//
//  RunningPlanView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/16/23.
//

import SwiftUI

struct RunningPlanView: View {
    @EnvironmentObject var planController: RunningPlanController
    @ObservedObject var viewController: RunningPlanDetailViewController
    var plan: RunningPlan {
        viewController.plan
    }

    @State var isSheetPresented: Bool = false
    
    var planIsSelected: Bool {
        viewController.plan == planController.selectedPlan?.plan
    }
    
    var body: some View {
        GeometryReader { g in
            VStack {
                RunningPlanHeader(plan: viewController.plan)
                    .padding([.horizontal])
                HStack {
                    Group {
                        Color.clear
                            .frame(maxWidth: 10, maxHeight: 10)
                        ForEach(0..<7) { idx in
                            Text(RunningPlan.dayDescription(dayIndex: idx) ?? "xx")
                                .frame(width: g.size.width/11)
                        }
                        Text("Tot")
                            .fontWeight(.ultraLight)
                            .frame(width: g.size.width/11)
                    }
                }
                
                ScrollView {
                    Grid {
                        Section {
                            ForEach(plan.goals) { week in
                                WeekHeader(week: week.id, planDate: planController.selectedPlan?.startDate)
                                RunningPlanWeekGridRow(week: week)
                            }
                        }
                        
                    }
                    .focusable()
                    .padding([.horizontal])
                    .padding(.top, 4)
                    .monospacedDigit()
                    .navigationTitle(plan.name)
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { self.isSheetPresented.toggle() }) {
                        Text(planIsSelected ? "Active" : "Select")
                    }
                    .disabled(planIsSelected)
                }
            }
            .sheet(isPresented: $isSheetPresented, content: {
                ConfirmationSheet(viewController, isBeingPresented: $isSheetPresented)
            })
            .onAppear {
                //This is necessary for long titles to be made smaller
                UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
            }
            
        }
    }
}

struct RunningPlanView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RunningPlanView(viewController: RunningPlanDetailViewController(plan: .monumental))
        }
    }
}
struct WeekHeader: View {
    var week: Int
    var planDate: Date?
    
    var weekText: Text {
        guard let planDate else {
            return Text("wk \(week + 1)")
        }
        let date = Calendar.current.date(byAdding: .day, value: 7 * week, to: planDate)!
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .none
        return Text(df.string(for: date) ?? "wk \(week + 1)")
    }
    
    var body: some View {
        HStack {
            weekText
                .font(.caption)
                .fontWeight(.ultraLight)
                .frame(height: 0)
            VStack {
                Divider()
            }
        }
    }
}

struct ConfirmationSheet: View {
    @EnvironmentObject var planController: RunningPlanController
    @ObservedObject var viewController: RunningPlanDetailViewController
    var plan: RunningPlan {
        viewController.plan
    }
    @Binding var isBeingPresented: Bool
    
    init(_ vc: RunningPlanDetailViewController, isBeingPresented: Binding<Bool>) {
        self.viewController = vc
        self._isBeingPresented = isBeingPresented
    }
    
    var body: some View {
        VStack {
            let milesPerRun = NumberFormatter.twoFractionalDigits.string(for: plan.milesPerRun)
            Text("This plan consists of \(plan.runCount) runs over \(plan.weeks) weeks with an average of \(milesPerRun!) miles per activity.")
            
            Text("Select either the start date or the end date:")
                .padding()
            
            DatePicker("Start Date", selection: $viewController.startDate, displayedComponents: .date)
                .datePickerStyle(.compact)
            
            DatePicker("End Date", selection: $viewController.endDate, displayedComponents: .date)
                .datePickerStyle(.compact)
            
            Button(action: {
                planController.selectedPlan = RunningPlanSelection(startDate: viewController.startDate, plan: self.plan)
                isBeingPresented.toggle()
            }) {
                Text("Confirm")
            }.buttonStyle(BorderedButtonStyle())
                .padding()
        }
        .padding()
        .presentationDetents([.height(300)])
    }
}
