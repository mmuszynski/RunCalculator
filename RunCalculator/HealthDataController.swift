//
//  HealthKitUtils.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/4/23.
//

import Foundation
import HealthKit

class HealthDataController: ObservableObject {
    var store: HKHealthStore?
    @Published var calculator = YearlyMileageCalculator()
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
        }
    }
    
    @Published var workouts: [HKWorkout] = []
    @Published var quantity: HKQuantity?
    
    func getWorkouts(startDate: Date, endDate: Date, _ completion: (([HKWorkout]?)->())?) {
        Task {
            if let status = try await store?.statusForAuthorizationRequest(toShare: [], read: [.workoutType()]) {
                switch status {
                case .unknown:
                    print("Authorization unknown")
                case .shouldRequest:
                    try await store?.requestAuthorization(toShare: [], read: [.workoutType()])
                    getWorkouts(startDate: startDate, endDate: endDate, completion)
                    return
                case .unnecessary:
                    print("Authorization Unnecessary")
                @unknown default:
                    fatalError()
                }
            }
        }
        
        let type = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { query, samples, error in
            completion?(samples as? [HKWorkout])
        }
        
        store?.execute(query)
    }
    
    func getWorkouts(startDate: Date, endDate: Date) async -> [HKWorkout] {
        let workouts = await withCheckedContinuation { continuation in
            getWorkouts(startDate: startDate, endDate: endDate) { workouts in
                continuation.resume(returning: workouts)
            }
        }
        return workouts?.sorted(by: { $0.startDate > $1.startDate }) ?? []
    }
    
    @MainActor func loadWorkouts(startDate: Date = .distantPast, endDate: Date = .distantFuture) async {
        let workouts = await getWorkouts(startDate: startDate, endDate: endDate)
        self.workouts = workouts
        self.computeSummaries()
        self.calculator.setWorkouts(workouts)
    }
    
    func summary(for interval: DateInterval, activity: HKWorkoutActivityType = .running) -> WorkoutPeriodSummary {
        var summary = WorkoutPeriodSummary()
        summary.interval = interval
        summary.workouts = self.workouts.filter({ workout in
            interval.contains(workout.startDate)
        })
        return summary
    }
    
    func summary(forYear year: Int, activity: HKWorkoutActivityType = .running) -> WorkoutPeriodSummary {
        var summary = WorkoutPeriodSummary(year: year)
        summary.workouts = self.workouts.filter({ workout in
            summary.interval.contains(workout.startDate)
        })
        return summary
    }
    
    enum SummaryPeriod: Hashable {
        case year
        case weeks(year: Int)
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .year:
                hasher.combine("year")
            case .weeks(let year):
                hasher.combine(year)
                hasher.combine("weeks")
            }
        }
        
        var description: String {
            switch self {
            case .year:
                return "Year"
            case .weeks(_):
                return "Week"
            }
        }
    }
    var summaryPeriod: SummaryPeriod = .year {
        didSet {
            self.computeSummaries()
        }
    }
    @Published var summaries: [WorkoutPeriodSummary] = []
    func computeSummaries() {
        switch summaryPeriod {
        case .year:
            Task {
                await MainActor.run {
                    self.summaries.append(summary(forYear: 2023))
                    self.summaries.append(summary(forYear: 2022))
                    self.summaries.append(summary(forYear: 2021))
                    self.summaries.append(summary(forYear: 2020))
                    self.summaries.append(summary(forYear: 2019))
                    self.objectWillChange.send()
                }
            }
        case .weeks(let year):
            let weeks = Calendar.current.date(from: DateComponents(year: year))!.weekIntervals
            self.summaries = weeks.map {
                self.summary(for: $0)
            }
            self.objectWillChange.send()
        }
    }
    
    func drillDown(for summary: WorkoutPeriodSummary) {
        switch summaryPeriod {
        case .year:
            //get year
            let year = summary.interval.start.year
            self.summaryPeriod = .weeks(year: year)
        case .weeks(let year):
            break
        }
    }
}

extension Array where Element == HKWorkout {
    var distances: [HKQuantity] {
        return self.compactMap(\.runningDistance)
    }
    
    var cumulativeDistance: HKQuantity {
        return distances.reduce(HKQuantity(unit: .meter(), doubleValue: 0)) { quantity, distance in
            return HKQuantity(unit: .meter(), doubleValue: quantity.doubleValue(for: .meter()) + distance.doubleValue(for: .meter()))
        }
    }
}
