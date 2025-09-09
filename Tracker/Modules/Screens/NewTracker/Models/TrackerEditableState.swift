//
//  TrackerEditableState.swift
//  Tracker
//
//  Created by Михаил Бобылев on 08.09.2025.
//

import UIKit

struct TrackerEditableState {
    let id: UUID
    var title: String
    var emoji: String
    var color: UIColor?
    var category: TrackerCategory?
    var weekdays: Set<WeekdayType>
    
    init(tracker: Tracker?, category: TrackerCategory?) {
        self.id = tracker?.id ?? UUID()
        self.title = tracker?.title ?? ""
        self.emoji = tracker?.emoji ?? ""
        self.color = tracker?.color
        self.category = category
        self.weekdays = tracker?.schedule ?? []
    }
}
