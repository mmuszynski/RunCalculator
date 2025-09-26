//
//  MileageGoal.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/7/24.
//

import Foundation

struct MileageGoal: Identifiable, Codable, Hashable {
    enum Unit: Codable, CaseIterable {
        case miles, kilometers
    }
    
    var id: UUID = UUID()
    
    var interval: DateInterval
    var target: Double
    
    var unit: Unit = .miles
    
    init() {
        self.init(miles: 500)
    }
    
    init(target: Double, unit: Unit = .miles, interval: DateInterval? = nil) {
        var interval = interval
        if interval == nil {
            interval = Calendar.current.dateInterval(of: .year, for: .current)
        }
        
        self.target = 500
        self.interval = interval!
        self.unit = unit
    }
    
    init(miles: Double, interval: DateInterval? = nil) {
        self.init(target: 500, interval: interval)
    }
    
    init(kilometers: Double, interval: DateInterval? = nil) {
        self.init(target: 500, unit: .kilometers, interval: interval)
    }
    
    var measurement: Measurement<UnitLength> {
        switch self.unit {
        case .miles:
            return Measurement(value: self.target, unit: .miles)
        case .kilometers:
            return Measurement(value: self.target, unit: .kilometers)
        }
    }
    
    var measurementDescription: String {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        return formatter.string(from: self.measurement)
    }
    
    var isExpired: Bool {
        self.interval.end < .current
    }
    
    var isUpcoming: Bool {
        self.interval.start > .current
    }
    
    var isCurrent: Bool {
        self.interval.contains(.current)
    }
    
    var milesTarget: Double {
        self.measurement.converted(to: .miles).value
    }
    
}

extension MileageGoal.Unit: CustomStringConvertible {
    var description: String {
        switch self {
        case .miles:
            return "mi"
        case .kilometers:
            return "km"
        }
    }
}

extension MileageGoal {
    static var example: MileageGoal {
        MileageGoal(miles: 500)
    }
    
    static var expired: MileageGoal {
        MileageGoal(miles: 500, interval: Calendar.current.dateInterval(of: .year, for: Calendar.current.date(byAdding: .year, value: -1, to: .current)!))
    }
}
