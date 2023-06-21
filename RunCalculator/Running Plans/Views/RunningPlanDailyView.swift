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
                .aspectRatio(1, contentMode: .fit)
                .foregroundStyle(isSelected ? .blue : .clear)
                .clipShape(Circle())
                .scaleEffect(0.8)
                .overlay {
                    Text(goal.miles.adaptivePrecisionString)
                        .foregroundColor(foreground)
                        .fontWeight(goal.miles == 0 ? .ultraLight : nil)
                        .fontWeight(isSelected ? .bold : nil)
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)
                }
        }
        .focusable(interactions: .edit)
    }
}

struct RunningPlanDailyView_Previews: PreviewProvider {
    static var previews: some View {
        HStack(spacing: 0) {
            RunningPlanDailyView(goal: .init(miles: 0, day: 1, week: 0))
                .frame(width: 30)
            RunningPlanDailyView(goal: .init(miles: 0, day: 1, week: 0), isSelected: true)
                .frame(width: 30)
        }
        .previewLayout(.sizeThatFits)
    }
}
