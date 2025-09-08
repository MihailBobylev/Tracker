//
//  FilterMode.swift
//  Tracker
//
//  Created by Михаил Бобылев on 08.09.2025.
//

import Foundation

enum FilterMode: String, CaseIterable {
    case allTrackers
    case todayTrackers
    case completedTrackers
    case uncompletedTrackers
    
    var title: String {
        switch self {
        case .allTrackers:
            return NSLocalizedString("all_trackers", comment: "Text displayed on title")
        case .todayTrackers:
            return NSLocalizedString("trackers_for_today", comment: "Text displayed on title")
        case .completedTrackers:
            return NSLocalizedString("completed", comment: "Text displayed on title")
        case .uncompletedTrackers:
            return NSLocalizedString("unfinished", comment: "Text displayed on title")
        }
    }
}
