//
//  GoalSelectionView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/8/24.
//

import SwiftUI

struct GoalSelectionView: View {
    @Environment(MileageGoalController.self) var controller
    
    var body: some View {
        @Bindable var controller = controller
        NavigationStack {
            List($controller.goals) { $goal in
                NavigationLink {
                    GoalEditView(goal: $goal)
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(goal.measurementDescription)
                            Text(goal.interval, formatter: DateIntervalFormatter.shortDate)
                        }
                        Spacer()
                        if goal.id == controller.selection {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                }
            }
        }
    }
}

#Preview {
    GoalSelectionView()
        .environment(MileageGoalController.example)
}
