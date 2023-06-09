//
//  DateUtilitiesMonth.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/3/23.
//

import Foundation

extension Date {
    var weekStarts: [Date] {
        return Date.weekStarts(forYearOf: self)
    }
    
    static func weekStarts(for year: Int) -> [Date] {
        let date = Calendar.current.date(from: DateComponents(year: year))!
        return weekStarts(forYearOf: date)
    }
    
    static func weekStarts(forYearOf date: Date) -> [Date] {
        let interval = Calendar.current.dateInterval(of: .year, for: date)

        var dates: [Date?] = [interval?.start]

        Calendar.current.enumerateDates(startingAfter: interval!.start, matching: DateComponents(weekday: 1), matchingPolicy: .strict) { result, exactMatch, stop in
            guard let result, interval?.contains(result) == true else {
                stop = true
                return
            }
            dates.append(result)
        }

        return dates.compactMap { $0 }
    }
    
    static var weeksRemainingInCurrentYear: Int {
        let now = Date()
        let weeks = Date.weekStarts(forYearOf: now)
        guard let currentWeek = weeks.firstIndex(where: { now < $0 }) else { fatalError() }
        
        return weeks.count - currentWeek
    }
    
    static func weekIndex(for date: Date) -> Int? {
        let weeks = Date.weekStarts(forYearOf: date)
        guard let currentWeek = weeks.firstIndex(where: { date < $0 }) else { return nil }
        return currentWeek
    }
    
    var weekNumber: Int {
        return Date.weekIndex(for: self) ?? 0
    }
    
    var weekOfYear: Int? {
        Calendar.current.component(.weekOfYear, from: self)
    }
    
    static func weekIntervals(for date: Date) -> [DateInterval] {
        let yearInterval = date.yearInterval!
        return date.weekStarts.compactMap { day in
            Calendar.current.dateInterval(of: .weekOfYear, for: day)?.intersection(with: yearInterval)
        }
    }
    
    var weekIntervals: [DateInterval] {
        Date.weekIntervals(for: self)
    }
}
