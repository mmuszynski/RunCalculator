//
//  RunningPlanDailyGoalEditView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/26/23.
//

import SwiftUI

struct RunningPlanEditControls: View {
    @EnvironmentObject var controller: RunningPlanController
    
    var dayDescription: String {
        guard let day = controller.selection?.day,
              let week = controller.selection?.week else {
            return "Select a day"
        }
        return "Week \(week + 1), " + (RunningPlan.longDayDescription(dayIndex: day) ?? "")
    }
    
    var body: some View {
        HStack {
            Button(action: {
                controller.increase(controller.selection,
                                    by: -1.0) })
            {
                Image(systemName: "minus.square.fill")
            }
            Button(action: {
                controller.increase(controller.selection,
                                    by: -0.1) })
            {
                Image(systemName: "minus.circle.fill")
            }
            Button(action: {
                controller.increase(controller.selection,
                                    by: 0.1) })
            {
                Image(systemName: "plus.circle.fill")
            }
            Button(action: {
                controller.increase(controller.selection,
                                    by: 1.0) })
            {
                Image(systemName: "plus.square.fill")
            }
        }
        .font(.largeTitle)
    }
}

struct RunningPlanDailyEditView_Previews: PreviewProvider {
    static var previews: some View {
        RunningPlanEditControls()
            .environmentObject(RunningPlanController())
    }
}
