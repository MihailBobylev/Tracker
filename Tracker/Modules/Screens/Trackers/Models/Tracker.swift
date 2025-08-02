//
//  Tracker.swift
//  Tracker
//
//  Created by Михаил Бобылев on 27.07.2025.
//

import UIKit

struct Tracker {
    let id = UUID()
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekdayType>
}
