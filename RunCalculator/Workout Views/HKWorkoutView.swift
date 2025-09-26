//
//  HKWorkoutView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/7/23.
//

import SwiftUI
import HealthKit

struct HKWorkoutView: View {
    var workout: HKWorkout
    init(_ workout: HKWorkout) {
        self.workout = workout
    }
    
    var timeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .medium
        return df
    }()
    
    var hmsFormatter: HMSFormatter = {
        let hms = HMSFormatter()
        hms.separator = .colon
        hms.unitStyle = .none
        return hms
    }()
    
    var mileage: Measurement<UnitLength>? {
        guard let value = workout.runningDistance?.doubleValue(for: .mile()) else { return nil }
        return Measurement(value: value, unit: .miles)
    }
    
    var body: some View {
        HStack {
            workout.image
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(workout.startDate,
                     formatter: self.timeFormatter)
                .font(.headline)
                
                if workout.runningDistance != nil {
                    Text(mileage!, formatter: .mileageFormatter)
                }
                
                Text(NSNumber(value: workout.duration),
                     formatter: hmsFormatter)
                .font(.callout)
                .fontWeight(.light)
                
                if workout.sourceRevision.source.name != "" {
                    Text(workout.sourceRevision.source.name)
                }
            }
        }.padding()
    }
}

struct HKWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        HKWorkoutView(.exampleRun)
            .previewLayout(.sizeThatFits)
    }
}

extension HKWorkout {
    static var exampleRun: HKWorkout {
        //        HKWorkout(activityType: .running,
        //                  start: Date(),
        //                  end: Date().addingTimeInterval(300),
        //        duration: 0)
        let wk = HKWorkout(activityType: .running,
                           start: .current,
                           end: .current.addingTimeInterval(3584),
                           duration: 0,
                           totalEnergyBurned: nil,
                           totalDistance: HKQuantity(unit: .mile(), doubleValue: 4),
                           metadata: nil)
        return wk
    }
}
