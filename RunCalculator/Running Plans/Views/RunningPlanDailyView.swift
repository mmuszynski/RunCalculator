//
//  RunningPlanDailyView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/26/23.
//

import SwiftUI

struct RunningPlanDailyView: View {
    var goal: RunningPlanDailyGoal
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
        ZStack {
            Rectangle()
                .foregroundStyle(isSelected ? .blue : .clear)
                .clipShape(Circle())
            Text(goal.miles.adaptivePrecisionString)
                .foregroundColor(foreground)
                .fontWeight(goal.miles == 0 ? .ultraLight : nil)
                .fontWeight(isSelected ? .bold : nil)
        }
    }
}

struct RunningPlanDailyView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            RunningPlanDailyView(goal: .init(miles: 0, day: 1, week: 0))
            RunningPlanDailyView(goal: .init(miles: 0, day: 1, week: 0), isSelected: true)
        }
    }
}
