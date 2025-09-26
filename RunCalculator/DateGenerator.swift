//
//  Date.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 8/5/23.
//

import Foundation
import OSLog

fileprivate let logger = Logger(category: "DateReporting")

extension Date {
    /// An extenstion-based variable that allows for computed versions of the current `Date`.
    ///
    /// Generally, `Date` allows for the current date to be referenced by initializing the object with no additional arguments. This is useful for retrieving the current date. However, in testing date-based functionality, it often requires the system to believe that the date or time is different than the value that the system provides by default. This method wraps a saved `DateGenerator` function that allows the current time to be replaced with another time generated time.
    ///
    /// Turns out `now` is taken.
    static var current: Date {
        let current =  DateGenerator.generateCurrentDate()
        return current
    }
}

public class DateGenerator {
    public typealias DateGeneratorType = () -> Date
    private static var lastGeneratedDate: Date?
    
    public static var currentDateGenerator: DateGeneratorType = {
        Date()
    }
    
    public static func generateCurrentDate() -> Date {
        let date = DateGenerator.currentDateGenerator()
        let interval = date.timeIntervalSince(lastGeneratedDate ?? .distantPast)
        
        if interval > 1 {
            logger.info("Date generator created current date of \(date, privacy: .public)")
            lastGeneratedDate = date
        }
        
        return date
    }
}
