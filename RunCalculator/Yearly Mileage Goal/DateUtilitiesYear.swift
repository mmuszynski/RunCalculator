//
//  DateUtilities.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 3/3/23.
//

import Foundation

extension Date {
    /// A date representing the beginning of the day for a given day and month in the year of the original date
    /// - Parameters:
    ///   - month: The month of the `Date` object's year required
    ///   - day: The day of the `Date` object's year required
    /// - Returns: A `Date` representing the day and month with the year of the original date
    func dateInYear(month: Int, day: Int) -> Date? {
        guard let year = Calendar.current.dateComponents([.year], from: self).year,
              let date = DateComponents(calendar: .current, year: year, month: month, day: day).date
        else {
            return nil
        }
        
        return date
    }
    
    var yearInterval: DateInterval? {
        return Calendar.current.dateInterval(of: .year, for: self)
    }
    
    var startOfYear: Date? {
        return Calendar.current.dateInterval(of: .year, for: self)?.start
    }
    
    var endOfYear: Date? {
        guard let year = Calendar.current.dateComponents([.year], from: self).year else { return nil }
        guard let nextYear = DateComponents(calendar: .current, year: year + 1).date else { return nil }
        let dayBeforeNextYear = Calendar.current.date(byAdding: .day, value: -1, to: nextYear)
        
        return dayBeforeNextYear
    }
    
    var dayOfYear: Int? {
        Calendar.current.ordinality(of: .day, in: .year, for: self)
    }
    
    var daysInYear: Int? {
        guard let endOfYear = self.endOfYear else { return nil }
        return Calendar.current.ordinality(of: .day, in: .year, for: endOfYear)
    }
    
    var monthOfYear: Int? {
        Calendar.current.component(.month, from: self)
    }
    
    var currentYear: DateComponents {
        Calendar.current.dateComponents([.year], from: self)
    }
    
    static func year(for date: Date) -> Int {
        Calendar.current.component(.year, from: date)
    }
    
    var year: Int {
        Date.year(for: self)
    }
}

//Static vars and functions
extension Date {
    static var currentYearStart: Date? {
        .current.startOfYear
    }
    
    static var currentYearEnd: Date? {
        .current.endOfYear
    }
}
