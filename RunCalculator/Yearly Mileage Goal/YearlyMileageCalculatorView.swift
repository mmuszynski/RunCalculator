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

//struct YearlyMileageCalculatorView: View {
//    @EnvironmentObject var hdc: HealthDataController
//    
//    var body: some View {
//        VStack {
//            CircularSliderView(value: $hdc.calculator.mileageAsOfToday,
//                               in: 0...500,
//                               trackWidth: 40)
//            {
//                ZStack {
//                    HStack {
//                        GeometryReader { g in
//                            Button(action: { hdc.calculator.fineTune(-0.1) }) { Image(systemName: "minus")
//                                    .font(.largeTitle)
//                            }
//                            .position(x: 0.85 * g.size.width / 4,
//                                          y: g.size.height / 2)
//                            Button(action: { hdc.calculator.fineTune(0.1) }) { Image(systemName: "plus")
//                                    .font(.largeTitle)
//                                
//                            }
//                            .position(x: 3.15 * g.size.width / 4,
//                                          y: g.size.height / 2)
//
//                        }
//                    }
//                    
//                    MileageInformationView()
//                }
//            }
//            .aspectRatio(1, contentMode: .fit)
//            .padding()
//            
//            Button(action: {
//                Task {
//                    await hdc.loadWorkouts()
//                }
//            }) {
//                Text("Calculate")
//            }
//        }
//    }
//}
//
//struct YearlyMileageCalculatorView_Previews: PreviewProvider {
//    static var previews: some View {
//        YearlyMileageCalculatorView()
//            .environmentObject(HealthDataController())
//    }
//}
