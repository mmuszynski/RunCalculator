//
//  DateRangeUtilities.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/13/23.
//

import Foundation

extension DateInterval {
    func clamped(to other: DateInterval) -> DateInterval {
        var start = self.start
        var end = self.end
        
        if self.start < other.start {
            start = other.start
        }
        
        if self.start > other.end {
            start = other.end
        }
        
        if self.end < other.start {
            end = other.start
        }
        
        if self.end > other.end {
            end = other.end
        }
        
        return DateInterval(start: start, end: end)
    }
}
