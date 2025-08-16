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
        case .monday: "Понедельник"
        case .tuesday: "Вторник"
        case .wednesday: "Среда"
        case .thursday: "Четверг"
        case .friday: "Пятница"
        case .saturday: "Суббота"
        case .sunday: "Воскресенье"
        }
    }
    
    var shortTitle: String {
        return switch self {
        case .monday: "Пн"
        case .tuesday: "Вт"
        case .wednesday: "Ср"
        case .thursday: "Чт"
        case .friday: "Пт"
        case .saturday: "Сб"
        case .sunday: "Вс"
        }
    }
    
    var mask: String {
        "\(self.rawValue)"
    }
}
