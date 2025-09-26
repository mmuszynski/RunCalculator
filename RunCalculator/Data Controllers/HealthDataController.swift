//
//  HealthKitUtils.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/4/23.
//

import Foundation
import HealthKit
import OSLog

fileprivate let logger = Logger(category: "HealthKitController")

class HealthDataController: ObservableObject {
    var store: HKHealthStore?
    @Published var calculator = MileageCalculator()
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            store = HKHealthStore()
        }
    }
    
    @Published var workouts: [HKWorkout] = []
    @Published var quantity: HKQuantity?
    
    @Published var isDoingWork: Bool = false
    @Published var lastCachedAt: Date?
    
    private func getWorkouts(startDate: Date, endDate: Date, _ completion: (([HKWorkout]?)->())?) {
        Task {
            if let status = try await store?.statusForAuthorizationRequest(toShare: [], read: [.workoutType()]) {
                switch status {
                case .unknown:
                    logger.info("Reported Authorization unknown")
                case .shouldRequest:
                    logger.info("Requesting workout authorization")
                    try await store?.requestAuthorization(toShare: [], read: [.workoutType()])
                    getWorkouts(startDate: startDate, endDate: endDate, completion)
                    return
                case .unnecessary:
                    logger.info("Reported Authorization Unnecessary")
                @unknown default:
                    fatalError()
                }
            }
            
            let type = HKSampleType.workoutType()
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
            
            let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: nil) { query, samples, error in
                
                logger.info("Returning HKSampleQuery with \(samples?.count ?? 0) samples")
                completion?(samples as? [HKWorkout])
            }
            
            logger.info("Executing HKSampleQuery")
            
            store?.execute(query)
        }
    }
    
    private func getWorkouts(startDate: Date = .distantPast, endDate: Date = .distantFuture) async -> [HKWorkout] {
        let workouts = await withCheckedContinuation { continuation in
            getWorkouts(startDate: startDate, endDate: endDate) { workouts in
                continuation.resume(returning: workouts)
            }
        }
        return workouts?.sorted(by: { $0.startDate > $1.startDate }) ?? []
    }
    
    private func appendWorkouts(_ workouts: [HKWorkout]) {
        let uniqueWorkouts = workouts.filter { !self.workouts.contains($0) }
        self.workouts.append(contentsOf: uniqueWorkouts)
        logger.debug("Added \(uniqueWorkouts.count) new workouts")
    }
    
    @MainActor func loadWorkouts(startDate: Date = .distantPast, endDate: Date = .distantFuture, usingCache: Bool = true) async {
        isDoingWork = true
        var startDate = startDate
        
        if startDate == .distantPast {
            startDate = workouts.max(by: { workout1, workout2 in
                workout1.endDate < workout2.endDate
            })?.endDate ?? .distantPast
        }
        
        startDate = startDate.advanced(by: 0.0001)
        
        logger.debug("Loading workouts from \(startDate)")
        
        if usingCache == false {
            workouts.removeAll()
            startDate = .distantPast
        }
        
        let newWorkouts = await getWorkouts(startDate: startDate, endDate: endDate)
        self.appendWorkouts(newWorkouts)
        
        self.computeSummaries()
        self.calculator.setWorkouts(workouts)
        isDoingWork = false
        
        self.lastCachedAt = Date()
    }
    
    func workouts(for interval: DateInterval) -> [HKWorkout] {
        self.workouts.filter { workout in
            interval.contains(workout.startDate)
        }
    }
    
    func mileage(for interval: DateInterval) -> Double {
        workouts(for: interval).mileage
    }
    
    func runkeeperMileage(for interval: DateInterval) -> Double {
        workouts(for: interval).runkeeperMileage
    }
    
    var cachedSummaries: [DateInterval : WorkoutPeriodSummaryCache] = [:]
    
    func summary(for interval: DateInterval, activity: HKWorkoutActivityType = .running) -> WorkoutPeriodSummary {
        //check for cached workouts before doing the calculation
        if let cached = cachedSummaries[interval],
           cached.expiry > .current {
            logger.trace("Returning cached workout period summary for \(interval)")
            return cached.summary
        }
        
        //also check to see if workouts are empty
        if workouts.isEmpty {
            var summary = WorkoutPeriodSummary()
            summary.interval = interval
            return summary
        }
        
        logger.trace("Calculating workout period summary for \(interval)")
        
        var summary = WorkoutPeriodSummary()
        summary.interval = interval
        summary.workouts = self.workouts.filter({ workout in
            interval.contains(workout.startDate)
        })
        
        //don't cache anything if the workouts are empty.
        if !workouts.isEmpty {
            cachedSummaries[interval] = WorkoutPeriodSummaryCache(summary: summary)
        }
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
        case .weeks(_):
            break
        }
    }
    
    /*
     - MARK: Chart Data
     ==========================================================================================
     Methods relating to the creation of chart data
     ==========================================================================================
     */
    
    @Published var cachedChartData: [ChartPoint] = []
    
    /// Calculates workout data and formats it for use in Swift Charts
    @MainActor func calculateChartData(workoutFilter: (HKWorkout)->Bool = { $0.sourceRevision.source.name == "Runkeeper" }) async {
        logger.debug("Retrieving data for chart")
        
        if !cachedChartData.isEmpty {
            logger.debug("Chart data found, using cached version")
            return
        }
        
        await self.loadWorkouts()
        
        /// Set up distance chart points with a line for required mileage
        var distances: [ChartPoint] = []
        distances.append(ChartPoint(day: 1, mileage: 0, group: "Required Mileage"))
        distances.append(ChartPoint(day: 365, mileage: 500, group: "Required Mileage"))
        
        /// Set up a year to deal with the current calculation
        var calculationYear: Int?
        
        /// Note that you can pass a filter on the workouts if necessary, but that it will default to only the Runkeeper workouts
        let relevantWorkouts = workouts.filter(workoutFilter).sorted { first, second in
            first.startDate < second.startDate
        }
        
        /// Set up a cumulative distance for the year and iterate over the workouts
        /// This seems to assume that the workouts are ordered by date, ascending, so I added that above
        var cumulativeDistance: Double = 0
        for workout in relevantWorkouts {
            
            /// If the year of the workout is different than the year that we are currently calculating, change the year that we are calculating
            if calculationYear != workout.startDate.year {
                cumulativeDistance = 0
                calculationYear = workout.startDate.year
            }
            
            /// When a new date is found, create a vertical line by adding a two points, each for the day of the year, with one representing the mileage before the workout and one with the mileage after the workout
            let date = workout.startDate
            distances.append(ChartPoint(day: date.dayOfYear!, mileage: cumulativeDistance, group: "\(date.year)"))
                
            if let distance = workout.runningDistance {
                cumulativeDistance += distance.doubleValue(for: .mile())
            }
                
            distances.append(ChartPoint(day: date.dayOfYear!, mileage: cumulativeDistance, group: "\(date.year)"))
        }
    
        //This doesn't take into account if you have a run scheduled but haven't done it yet
        
        if let plan = try? RunningPlanSelection.loadSelectedPlan() {
            let today = DateInterval.today.start
            let upcoming = plan.upcomingGoals(after: today)
            distances.append(ChartPoint(day: today.dayOfYear!, mileage: cumulativeDistance, group: "Proposed"))

            for goal in upcoming {
                let goalDate = plan.dateInterval(for: goal)!.start.dayOfYear!
                distances.append(ChartPoint(day: goalDate, mileage: cumulativeDistance, group: "Proposed"))
                cumulativeDistance += goal.miles
                distances.append(ChartPoint(day: goalDate, mileage: cumulativeDistance, group: "Proposed"))
            }
        }
        
        self.cachedChartData = distances
    }
    
    func resetCaches() {
        self.workouts = []
        self.cachedChartData = []
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
