//
//  MileageChart.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/4/23.
//

import SwiftUI
import Charts
import HealthKit

extension Date: Identifiable {
    public var id: Self { self }
}

struct ChartPoint: Identifiable {
    var id: UUID = UUID()
    var day: Int
    var mileage: Double
    var group: String
}

extension ClosedRange where Bound: BinaryInteger {
    static func +(lhs: Self, rhs: any BinaryInteger) -> Self {
        let lower = lhs.lowerBound + Self.Bound.init(rhs)
        let upper = lhs.upperBound + Self.Bound.init(rhs)
        return lower...upper
    }
    static func -(lhs: Self, rhs: any BinaryInteger) -> Self {
        let lower = lhs.lowerBound - Self.Bound.init(rhs)
        let upper = lhs.upperBound - Self.Bound.init(rhs)
        return lower...upper
    }
    
    static func +=(lhs: inout Self, rhs: any BinaryInteger) {
        lhs = lhs + rhs
    }
    
    static func -=(lhs: inout Self, rhs: any BinaryInteger) {
        lhs = lhs - rhs
    }
    
    func scaled<T: BinaryFloatingPoint>(by scale: T) -> Self {
        let center = T(self.upperBound - self.lowerBound) / 2
        let lower = T(self.lowerBound) * scale
        let upper = T(self.upperBound) * scale
        let newRange = upper - lower
        return Self.Bound(center - newRange / 2)...Self.Bound(center + newRange / 2)
    }
}

func +(lhs: CGPoint, rhs: CGSize) -> CGPoint {
    CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
}

extension CGSize {
    func scaled(by scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
    }
}

struct MileageChart: View {
    @EnvironmentObject var hdc: HealthDataController
    var mileageCalculator = YearlyMileageCalculator()
    
    @State var distances: [ChartPoint] = []
    
    func requiredMileage(for date: Date) -> Double {
        let miles: Double = 500
        let dayOfYear = date.dayOfYear!
        let daysInYear = date.daysInYear!
        return miles / Double(daysInYear) * Double(dayOfYear)
    }
    
    func recalculate() {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        let end = Date.currentYearEnd!
        
        hdc.getWorkouts(startDate: date, endDate: end) { workouts in
            
            var distances: [ChartPoint] = []
            distances.append(ChartPoint(day: 1, mileage: 0, group: "Required Mileage"))
            distances.append(ChartPoint(day: 365, mileage: 500, group: "Required Mileage"))
            
            var calculationYear: Int?
            
            if let workouts = workouts?.filter({ $0.sourceRevision.source.name == "Runkeeper" }) {
                var cumulativeDistance: Double = 0
                for workout in workouts {
                    if calculationYear != workout.startDate.year {
                        cumulativeDistance = 0
                        calculationYear = workout.startDate.year
                    }
                    
                    
                    let date = workout.startDate
                    distances.append(ChartPoint(day: date.dayOfYear!, mileage: cumulativeDistance, group: "\(date.year)"))
                    
                    if let distance = workout.runningDistance {
                        cumulativeDistance += distance.doubleValue(for: .mile())
                    }
                    
                    distances.append(ChartPoint(day: date.dayOfYear!, mileage: cumulativeDistance, group: "\(date.year)"))
                    
                }
                
                self.distances = distances
            }
        }
    }
    
    @State var year: Int = 2023
    
    @State private var _chartCenter: CGPoint = CGPoint(x: 365 / 2, y: 600 / 2)
    var chartCenter: CGPoint {
        _chartCenter + dragState.applying(CGAffineTransform(scaleX: -1, y: 1))
    }
    @State private var _magnification: CGFloat = 1
    var magnification: CGFloat {
        _magnification / magState
    }
    @State private var _chartSize: CGSize = CGSize(width: 365, height: 600)
    var chartSize: CGSize {
        _chartSize.scaled(by: magnification)
    }
    
    var chartDisplayRangeX: ClosedRange<Int> {
        Int(chartCenter.x - chartSize.width / 2)...Int(chartCenter.x + chartSize.width / 2)
    }
    var chartDisplayRangeY: ClosedRange<Int> {
        Int(chartCenter.y - chartSize.height / 2)...Int(chartCenter.y + chartSize.height / 2)
    }
    
    @GestureState var dragState: CGSize = .zero
    var drag: some Gesture {
            DragGesture()
            .updating($dragState, body: { value, state, tx in
                state = value.translation
            })
            .onEnded { value in
                _chartCenter = _chartCenter + value.translation.applying(.init(scaleX: -1, y: 1))
            }
        }
    
    @GestureState var magState: CGFloat = 1
    var mag: some Gesture {
        MagnificationGesture()
            .updating($magState) { mag, state, tx in
                state = mag
            }
            .onEnded { value in
                self._magnification = _magnification / value
            }
    }
    
    
    var body: some View {
        VStack {
            Chart(distances) {
                LineMark(x: .value("Date", $0.day),
                         y: .value("Distance", $0.mileage),
                         series: .value("Group", $0.group))
                .foregroundStyle(by: .value("Group", $0.group))
            }
            .chartXScale(domain: chartDisplayRangeX)
            .chartYScale(domain: chartDisplayRangeY)
        }
        .onAppear {
            self.recalculate()
        }
        .gesture(drag)
        .gesture(mag)
            
        
    }
}

struct MileageChart_Previews: PreviewProvider {
    static var previews: some View {
        MileageChart()
            .environmentObject(HealthDataController())
    }
}
