//
//  HKWorkoutSummaryGrid.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/12/23.
//

import SwiftUI

struct HKWorkoutSummaryGrid: View {
    @EnvironmentObject var controller: HealthDataController
    
    var body: some View {
        if controller.summaries.isEmpty {
            Text("Empty.")
                .font(.largeTitle)
                .foregroundColor(.gray)
        } else {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(controller.summaries, id: \.self) { summary in
                        Button(action: {
                            controller.drillDown(for: summary)
                        }) {
                            HKWorkoutSummaryCard(summary)
                        }
                    }
                }
            }
        }
    }
}

struct HKWorkoutSummaryGrid_Previews: PreviewProvider {
    static var previews: some View {
        HKWorkoutSummaryGrid()
            .environmentObject(HealthDataController())
    }
}
