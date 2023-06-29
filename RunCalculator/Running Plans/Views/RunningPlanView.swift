//
//  RunningPlanView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/16/23.
//

import SwiftUI

struct RunningPlanView: View {
    @Binding var plan: RunningPlan
    @FocusState var isEditing: Bool
    
    var body: some View {
        GeometryReader { g in
            VStack {
                ScrollView {
                    Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                        
                        RunningPlanHeaderGridRow()
                        
                        ForEach(plan.goals) { week in
                            WeekHeader(week: week.id)
                            RunningPlanWeekGridRow(week: week)
                        }
                        
                    }
                    .padding()
                    .monospacedDigit()
                    .navigationTitle(plan.name)
                }
            }
        }
    }
}

struct RunningPlanView_Previews: PreviewProvider {
    static var previews: some View {
        RunningPlanView(plan: .constant(.monumental))
            .padding()
    }
}

struct WeekHeader: View {
    var week: Int
    
    var body: some View {
        HStack {
            Text("wk \(week + 1)")
                .font(.caption)
                .fontWeight(.ultraLight)
                .frame(height: 0)
            VStack {
                Divider()
            }
        }
    }
}
