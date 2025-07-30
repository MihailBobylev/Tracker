//
//  Set+Extension.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

extension Set where Element == WeekdayType {
    var labelText: String? {
        guard !self.isEmpty else { return nil}
        
        let allDays = Set(WeekdayType.allCases)
        
        if self == allDays {
            return "Каждый день"
        }
        
        let orderedDays = WeekdayType.allCases
        let selectedOrdered = orderedDays.filter { self.contains($0) }
        let titles = selectedOrdered.map { $0.shortTitle }
        return titles.joined(separator: ", ")
    }
}
