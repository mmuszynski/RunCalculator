//
//  DateIntervalHelpers.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/11/23.
//

import Foundation

extension DateIntervalFormatter {
    static var longDate: DateIntervalFormatter = .init(timeStyle: .none, dateStyle: .long)
    static var shortDate: DateIntervalFormatter = .init(timeStyle: .none, dateStyle: .short)
    
    convenience init(timeStyle: DateIntervalFormatter.Style = .none, dateStyle: DateIntervalFormatter.Style = .none) {
        self.init()
        self.timeStyle = timeStyle
        self.dateStyle = dateStyle
    }
}

extension MeasurementFormatter {
    static var forMileage: MeasurementFormatter = {
        let nf = MeasurementFormatter()
        nf.numberFormatter.maximumFractionDigits = 2
        return nf
    }()
}

extension Formatter {
    static var mileageFormatter: MeasurementFormatter = .forMileage
    static var longDateFormatter: DateIntervalFormatter = .longDate
    static var shortDateFormatter: DateIntervalFormatter = .shortDate
}

extension Double {
    var lowPrecisionString: String {
        String(format: "%.2f", self)
    }
    
    var adaptivePrecisionString: String {
        if self.truncate(places: 0) == self {
            return String(format: "%.0f", self)
        } else if self.truncate(places: 1) == self {
            return String(format: "%.1f", self)
        }
        return String(format: "%.2f", self)
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
