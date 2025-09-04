//
//  ScheduleSectionType.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

enum WeekdayType: Int, CaseIterable, Codable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var title: String {
        return switch self {
        case .monday: NSLocalizedString("monday", comment: "monday text")
        case .tuesday: NSLocalizedString("tuesday", comment: "tuesday text")
        case .wednesday: NSLocalizedString("wednesday", comment: "wednesday text")
        case .thursday: NSLocalizedString("thursday", comment: "thursday text")
        case .friday: NSLocalizedString("friday", comment: "friday text")
        case .saturday: NSLocalizedString("saturday", comment: "saturday text")
        case .sunday: NSLocalizedString("sunday", comment: "sunday text")
        }
    }
    
    var shortTitle: String {
        return switch self {
        case .monday: NSLocalizedString("monday_short", comment: "monday short text")
        case .tuesday: NSLocalizedString("tuesday_short", comment: "tuesday short text")
        case .wednesday: NSLocalizedString("wednesday_short", comment: "wednesday short text")
        case .thursday: NSLocalizedString("thursday_short", comment: "thursday short text")
        case .friday: NSLocalizedString("friday_short", comment: "friday short text")
        case .saturday: NSLocalizedString("saturday_short", comment: "saturday short text")
        case .sunday: NSLocalizedString("sunday_short", comment: "sunday short text")
        }
    }
    
    var mask: String {
        "\(self.rawValue)"
    }
}
