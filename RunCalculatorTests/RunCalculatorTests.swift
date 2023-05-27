//
//  RunCalculatorTests.swift
//  RunCalculatorTests
//
//  Created by Mike Muszynski on 3/3/23.
//

import XCTest
@testable import RunCalculator

extension Date {
    fileprivate init(year: Int, month: Int, day: Int) {
        self = DateComponents(calendar: .current, year: year, month: month, day: day).date!
    }
}

final class RunCalculatorTests: XCTestCase {
    
    /// Test the dates for the beginning and end of the year
    func testDates() throws {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        XCTAssertNotNil(date.dayOfYear)
        XCTAssertNotNil(date.daysInYear)
        XCTAssertNotNil(date.startOfYear)
        XCTAssertNotNil(date.endOfYear)
        
        XCTAssertEqual(date.startOfYear?.dayOfYear, 1)
        XCTAssertEqual(date.endOfYear?.dayOfYear, 366)

        XCTAssertEqual((date.endOfYear?.dayOfYear ?? 0) - (date.startOfYear?.dayOfYear ?? 0) + 1, date.daysInYear)
        XCTAssertEqual(date.weekOfYear, 1)
    }
    
    func testWeekDivisions() throws {
        //y2k starts on a saturday, so the zero index week should include only that particular day
        let ranges = Date.weekStarts(for: 2001)
        XCTAssertEqual(ranges[0], .init(year: 2001, month: 1, day: 1))
        
        let secondWeek = DateComponents(calendar: .current, year: 2001, month: 1, day: 7).date!
        XCTAssertEqual(ranges[1], secondWeek)
    }
    
    func testNumWeeks() throws {
        XCTAssertEqual(Date.weekStarts(for: 2001).count, 53)
        XCTAssertEqual(Date.weekStarts(for: 2022).count, 54)
    }
    
    func testWeeksLeft() throws {
        XCTAssertEqual(Date.init(year: 2023, month: 5, day: 6).weekNumber, 126/7)
        XCTAssertEqual(Date.init(year: 2023, month: 1, day: 1).weekNumber, 1)
        XCTAssertEqual(Date.init(year: 2023, month: 1, day: 8).weekNumber, 2)
        XCTAssertEqual(Date.init(year: 2022, month: 1, day: 1).weekNumber, 1)
    }

}
