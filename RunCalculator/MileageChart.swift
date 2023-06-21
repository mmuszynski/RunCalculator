//
//  MileageChart.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/4/23.
//

import SwiftUI
import Charts
import HealthKit

struct ChartPoint: Identifiable {
    var id: UUID = UUID()
    var day: Int
    var mileage: Double
    var group: String
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
    
    var body: some View {
        VStack {
            Chart(distances) {
                LineMark(x: .value("Date", $0.day),
                         y: .value("Distance", $0.mileage),
                         series: .value("Group", $0.group))
                .foregroundStyle(by: .value("Group", $0.group))
            }
        }
        .task {
            self.distances = await hdc.calculateChartData()
        }
        .chartXVisibleDomain(length: 100)
        .chartYVisibleDomain(length: 100)
        .chartScrollPosition(initialX: 0)
        .chartScrollPosition(initialY: 0)
        .chartScrollTargetBehavior(.valueAligned(unit: 25))
        .chartScrollableAxes([.horizontal, .vertical])
        .padding()
            
        
    }
}

struct MileageChart_Previews: PreviewProvider {
    static var previews: some View {
        MileageChart()
            .environmentObject(HealthDataController())
    }
}
