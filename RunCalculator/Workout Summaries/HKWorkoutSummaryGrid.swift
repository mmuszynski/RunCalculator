//
//  HKWorkoutSummaryGrid.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/12/23.
//

import SwiftUI

struct HKWorkoutSummaryGrid: View {
    @EnvironmentObject var hdc: HealthDataController
    @State var pickerPeriod: HealthDataController.SummaryPeriod = .year
    
    var body: some View {
        if hdc.summaries.isEmpty {
            Text("Empty.")
                .font(.largeTitle)
                .foregroundColor(.gray)
        } else {
            Picker("Period", selection: $pickerPeriod) {
                ScrollView(.horizontal) {
                    LazyHStack {
                        ForEach(hdc.summaries, id: \.self) { summary in
                            Button(action: {
                                hdc.drillDown(for: summary)
                            }) {
                                HKWorkoutSummaryCard(summary)
                            }
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
