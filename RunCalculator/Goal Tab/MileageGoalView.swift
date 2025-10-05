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
                Text("Goal: \(goal.measurement, formatter: .mileageFormatter)")
            .font(.largeTitle)
            .fontWeight(.semibold)
            
            Text(goal.interval, formatter: DateIntervalFormatter(timeStyle: .none, dateStyle: .short))
            
            MileagePieChart()
                .aspectRatio(contentMode: .fit)
                .environment(MileageGoalViewController(hdc: hdc, goal: goal))
        }
        .padding()
    }
    
    
}

#Preview {
    NavigationStack {
        MileageGoalView(goal: .example)
            .environmentObject(HealthDataController())
    }
}
