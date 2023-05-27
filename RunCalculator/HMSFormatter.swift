//
//  HMSFormatter.swift
//  RunCalculator
//
//  Created by Mike Muszynski on 5/7/23.
//

import Foundation

class HMSFormatter: Formatter {
    enum SeparatorStyle {
        case comma
        case space
        case colon
        
        var separator: String {
            switch self {
            case .comma:
                return ", "
            case .space:
                return " "
            case .colon:
                return ":"
            }
        }
    }
    
    enum UnitStyle {
        case none, short, long
        
        func hourStyle(for num: Int) -> String {
            switch self {
            case .none:
                return ""
            case .short:
                return "h"
            case .long:
                if num != 1 { return " hours" }
                return " hour"
            }
        }
        
        func minuteStyle(for num: Int) -> String {
            switch self {
            case .none:
                return ""
            case .short:
                return "m"
            case .long:
                if num != 1 { return " minutes" }
                return " minute"
            }
        }
        
        func secondStyle(for num: Int) -> String {
            switch self {
            case .none:
                return ""
            case .short:
                return "s"
            case .long:
                if num != 1 { return " seconds" }
                return " second"
            }
        }
    }
    
    var separator: SeparatorStyle = .colon
    var unitStyle: UnitStyle = .short
    
    override func string(for obj: Any?) -> String? {
        guard let doubleInterval = obj as? TimeInterval else { return nil }
        let interval = Int(doubleInterval)
        let hours = interval / 3600
        let minutes = (interval - hours * 3600) / 60
        let seconds = (interval - hours * 3600 - minutes * 60)
        
        var stringParts = [String]()
        
        if hours > 0 {
            stringParts.append(String(format: "%d\(self.unitStyle.hourStyle(for: hours))", hours))
        }
        
        if minutes > 0 || unitStyle == .none {
            stringParts.append(String(format: "%02d\(self.unitStyle.minuteStyle(for: minutes))", minutes))
        }
        
        if seconds > 0 || unitStyle == .none {
            stringParts.append(String(format: "%02d\(self.unitStyle.secondStyle(for: seconds))", seconds))
        }
        
        
        return stringParts.joined(separator: separator.separator)
    }
}
