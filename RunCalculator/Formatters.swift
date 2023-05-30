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

extension NumberFormatter {
    static func precision(_ fraction: Int) -> NumberFormatter {
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 2
        return nf
    }
}

extension Formatter {
    static var mileageFormatter: MeasurementFormatter = .forMileage
    static var longDateFormatter: DateIntervalFormatter = .longDate
    static var shortDateFormatter: DateIntervalFormatter = .shortDate
    static var twoFractionalDigits: NumberFormatter = .precision(2)
}

extension Double {
    var lowPrecisionString: String {
        String(format: "%.2f", self)
    }
    
    var adaptivePrecisionString: String {
        let num = NSNumber(value: self)
        return NumberFormatter.precision(2).string(from: num) ?? "--"
    }
}

extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)).rounded() * self)/pow(10.0, Double(places)))
    }
}
