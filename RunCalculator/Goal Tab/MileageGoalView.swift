//
//  MieageGoalView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 9/28/25.
//

import SwiftUI

struct MileageGoalView : View {
    var goal: MileageGoal
    @EnvironmentObject var hdc: HealthDataController
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            Group {
                Text("Goal: ") +
                Text(goal.measurement, formatter: .mileageFormatter)
            }
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.leading)
            
            Text(goal.interval, formatter: DateIntervalFormatter(timeStyle: .none, dateStyle: .short))
                .padding(.leading)
            
            MileagePieChart()
                .aspectRatio(contentMode: .fit)
                .padding()
                .environment(MileageGoalViewController(hdc: hdc, goal: goal))
            Spacer()
        }
    }
    
    
}

