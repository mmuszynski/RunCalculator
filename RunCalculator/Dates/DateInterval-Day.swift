//
//  DateInterval-Day.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/22/23.
//

import Foundation

extension DateInterval {
    func interval(for: Calendar.Component, year: Int, month: Int, day: Int) -> DateInterval? {
        guard let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day)) else { return nil }
        return Calendar.current.dateInterval(of: .day, for: date)
    }
}
