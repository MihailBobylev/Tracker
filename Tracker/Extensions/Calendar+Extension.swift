//
//  Calendar+Extension.swift
//  Tracker
//
//  Created by Михаил Бобылев on 02.08.2025.
//

import Foundation

extension Calendar {
    func isDateInFuture(_ date: Date) -> Bool {
        startOfDay(for: date) > startOfDay(for: Date())
    }
    
    func weekdayType(from date: Date) -> WeekdayType? {
        let weekday = component(.weekday, from: date)
        return switch weekday {
        case 1: .sunday
        case 2: .monday
        case 3: .tuesday
        case 4: .wednesday
        case 5: .thursday
        case 6: .friday
        case 7: .saturday
        default: nil
        }
    }
}
