//
//  ScheduleService.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

final class ScheduleService {
    func fetchSchedule() -> [WeekdayType] {
        return [
            .monday,
            .tuesday,
            .wednesday,
            .thursday,
            .friday,
            .saturday,
            .sunday
        ]
    }
}
