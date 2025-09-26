//
//  HKWorkout+Image.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/3/24.
//

import HealthKit
import SwiftUI

extension HKWorkout {
    var image: some View {
        VStack {
            switch self.workoutActivityType {
            case .running:
                Image(systemName: "figure.run.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45)
                    .foregroundColor(.green)
            case .walking:
                Image(systemName: "figure.walk.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45)
                    .foregroundColor(.blue)
            case .cycling:
                Image(systemName: "bicycle.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 45)
                    .foregroundColor(.red)
            default:
                Image(systemName: "questionmark.circle.fill")
                Text("\(self.workoutActivityType.rawValue)")
            }
        }
    }
}

