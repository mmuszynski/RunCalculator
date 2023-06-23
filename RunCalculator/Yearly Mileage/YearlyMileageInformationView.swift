//
//  YearlyMileageInformationView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/22/23.
//

import SwiftUI

struct YearlyMileageInformationView: View {
    @EnvironmentObject var hdc: HealthDataController
    
    var measurementFormatter: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 1
        nf.minimumFractionDigits = 1
        formatter.numberFormatter = nf
        return formatter
    }
    
    func formattedString(from measurement: Measurement<UnitLength>) -> String {
        measurementFormatter.string(from: measurement)
    }
    
    var formattedMileageGoal: String {
        formattedString(from: hdc.calculator.mileageGoal.miles)
    }
    
    var formattedCurrentMileage: String {
        formattedString(from: hdc.calculator.mileageAsOfToday.miles)
    }
    
    var formattedMileageRemaining: String {
        formattedString(from: hdc.calculator.mileageRemainingAsOfToday.miles)
    }

    var formattedCompleteMileageRate: String {
        formattedString(from: hdc.calculator.completeMileageRate.miles)
    }
    
    var formattedRemainingMileageRate: String {
        formattedString(from: hdc.calculator.requiredMileageRate.miles)
    }
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack {
            Group {
                Text(formattedCurrentMileage)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                Text("of \(formattedMileageGoal)")
            }
            .monospacedDigit()
            
            Group {
                Text(formattedCompleteMileageRate + "/" + hdc.calculator.mileageTimeframe.rawValue)
                    .monospacedDigit()
                Spacer()
                    .frame(height: 10)
                Text("\(formattedMileageRemaining) remaining")
                Text(" over \(hdc.calculator.remainingTimeframeDescription)")
   
                Text("\(formattedRemainingMileageRate)/\(hdc.calculator.mileageTimeframe.rawValue) to reach goal")
                    .fontWeight(.semibold)
            }
            .fontDesign(.rounded)
            .monospacedDigit()
            .onTapGesture {
                hdc.calculator.nextTimeframe()
            }
        }
    }
}

#Preview {
    YearlyMileageInformationView()
        .environmentObject(HealthDataController())
}
