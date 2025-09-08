//
//  TrackerEditMode.swift
//  Tracker
//
//  Created by Михаил Бобылев on 08.09.2025.
//

import Foundation

enum TrackerEditMode {
    case create
    case edit(tracker: Tracker)
    
    var title: String {
        switch self {
        case .create:
            return NSLocalizedString("new_habit", comment: "title text")
        case .edit:
            return NSLocalizedString("edit_habit", comment: "title text")
        }
    }
    
    var editableTracker: Tracker? {
        switch self {
        case .create: return nil
        case .edit(let tracker): return tracker
        }
    }
}
