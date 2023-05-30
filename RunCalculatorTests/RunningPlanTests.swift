//
//  RunningPlanTests.swift
//  RunCalculatorTests
//
//  Created by Mike Muszynski on 5/25/23.
//

import XCTest
@testable import RunCalculator

final class RunningPlanTests: XCTestCase {
    
    func testDoubleEquality() {
        let double = 4.5
        XCTAssertEqual(double.truncate(places: 2), double)
    }
    
    func testStringOuputForDouble() {
        let double = 4.0
        let oneSig = 4.5
        let twoSig = 4.25
        let multisig = 4.3875
        
        XCTAssertEqual(double.adaptivePrecisionString, "4")
        XCTAssertEqual(oneSig.adaptivePrecisionString, "4.5")
        XCTAssertEqual(twoSig.adaptivePrecisionString, "4.25")
        XCTAssertEqual(multisig.adaptivePrecisionString, "4.39")
        
        var additionErrors = 0.0
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.1")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.2")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.3")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.4")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.5")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.6")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.7")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.8")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "0.9")
        additionErrors += 0.1
        XCTAssertEqual(additionErrors.adaptivePrecisionString, "1")
        
    }

}
