//
//  RunningPlanDailyGoalEditView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/26/23.
//

import SwiftUI

struct RunningPlanDailyEditView: View {
    @Binding var goal: RunningPlanDailyGoal?
    @State private var miles: Double = 0
    @FocusState private var focus: Bool
    
    var body: some View {
        TextField("Miles", value: Binding(get: {
            goal?.miles ?? 0
        }, set: { value, tx in
            goal?.miles = value
        }), format: .number)
            .font(.system(size: 100))
            .fontDesign(.rounded)
            .monospacedDigit()
            .keyboardType(.decimalPad)
            .focused($focus, equals: true)
            .onAppear {
                self.focus = true
            }
    }
}

struct RunningPlanDailyEditView_Previews: PreviewProvider {
    static var previews: some View {
        RunningPlanDailyEditView(goal: .constant(nil))
    }
}
