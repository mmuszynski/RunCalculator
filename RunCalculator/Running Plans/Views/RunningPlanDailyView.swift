//
//  RunningPlanDailyView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/26/23.
//

import SwiftUI

struct RunningPlanDailyView: View {
    @Binding var goal: RunningPlanDailyGoal
    var isSelected: Bool = false
    
    var foreground: Color? {
        if isSelected {
            return .white
        } else if goal.miles == 0 {
            return .secondary
        } else {
            return .primary
        }
    }
    
    var body: some View {
        TextField("Miles", value: $goal.miles, format: .number)
        Text(goal.miles.adaptivePrecisionString)
            .foregroundColor(foreground)
            .frame(minWidth: 40, minHeight: 40)
            .background {
                (isSelected ? Color.blue : Color.clear)
                    .clipShape(Circle())
            }
    }
}

struct RunningPlanDailyView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            RunningPlanDailyView(goal: .constant(.init(miles: 0, day: 1, week: 0)))
            RunningPlanDailyView(goal: .constant(.init(miles: 0, day: 1, week: 0)), isSelected: true)
        }
    }
}
