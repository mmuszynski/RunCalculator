//
//  HKWorkoutSummaryCard.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/11/23.
//

import SwiftUI
import HealthKit

struct HKWorkoutSummaryCard: View {
    var summary: WorkoutPeriodSummary
    init(summary: WorkoutPeriodSummary) {
        self.summary = summary
    }
    init(_ summary: WorkoutPeriodSummary) {
        self.init(summary: summary)
    }
    
    var body: some View {
        VStack {
            Text(summary.interval, formatter: DateIntervalFormatter(dateStyle: .medium))
            Text(summary.runningDistance, formatter: .mileageFormatter)
                .font(.largeTitle)
                .padding()
            if summary.workouts.isEmpty {
                Text("No Workouts")
            } else {
                let count = summary.workouts.filter {
                    $0.sourceRevision.source.name == "Runkeeper"
                }.count
                Text("\(count)" + " workout" + (count != 1 ? "s" : ""))
            }
        }
        .padding()
        .background(Color
            .white
            .cornerRadius(20)
            .shadow(radius: 8.0)
            .opacity(0.25)
        )
    }
}

struct HKWorkoutSummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        HKWorkoutSummaryCard(summary: .example)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
