//
//  YearlyMileageCalculatorView.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/3/23.
//

import SwiftUI

extension BinaryFloatingPoint {
    var miles: Measurement<UnitLength> {
        return Measurement(value: Double(self), unit: .miles)
    }
}

struct YearlyMileageCalculatorView: View {
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
            CircularSliderView(value: $hdc.calculator.mileageAsOfToday,
                               in: 0...500,
                               trackWidth: 40)
            {
                ZStack {
                    HStack {
                        GeometryReader { g in
                            Button(action: { hdc.calculator.fineTune(-0.1) }) { Image(systemName: "minus")
                                    .font(.largeTitle)
                            }
                            .position(x: 0.85 * g.size.width / 4,
                                          y: g.size.height / 2)
                            Button(action: { hdc.calculator.fineTune(0.1) }) { Image(systemName: "plus")
                                    .font(.largeTitle)
                                
                            }
                            .position(x: 3.15 * g.size.width / 4,
                                          y: g.size.height / 2)

                        }
                    }
                    
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
            .aspectRatio(1, contentMode: .fit)
            .padding()
            
            Button(action: {
                Task {
                    await hdc.loadWorkouts()
                }
            }) {
                Text("Calculate")
            }
        }
    }
}

struct YearlyMileageCalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        YearlyMileageCalculatorView()
            .environmentObject(HealthDataController())
    }
}
