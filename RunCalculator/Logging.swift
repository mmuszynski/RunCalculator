//
//  Logging.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 6/7/23.
//

import Foundation
import OSLog


extension Logger {
    init(category: String) {
        self.init(subsystem: "com.mmuszynski.RunCalculator", category: category)
    }
}
