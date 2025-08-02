//
//  TrackersDataProvider.swift
//  Tracker
//
//  Created by Михаил Бобылев on 31.07.2025.
//

import Foundation

final class TrackersDataProvider {
    private let calendar = Calendar.current
    private var categories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    
    var visibleCategories: [TrackerCategory] = [] {
        didSet {
            categoriesChanged?(visibleCategories.isEmpty)
        }
    }

    var categoriesChanged: ((Bool) -> Void)?
    
    func trackers(for date: Date) {
        guard let weekday = calendar.weekdayType(from: date) else { return }
        
        visibleCategories = categories.compactMap { category in
            let newCategory = TrackerCategory(
                title: category.title,
                trackers: category.trackers.filter { tracker in
                    tracker.schedule.contains(weekday)
                }
            )
            
            return newCategory.trackers.count > 0 ? newCategory : nil
        }
    }
    
    func isCompleted(_ tracker: Tracker, on date: Date?) -> Bool {
        guard let date else { return false }
        return completedTrackers.contains { $0.id == tracker.id && calendar.isDate($0.completionDate, inSameDayAs: date) }
    }
    
    func completedDays(for tracker: Tracker) -> Int {
        completedTrackers.filter { $0.id == tracker.id }.count
    }
    
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String) {
        var newCategories: [TrackerCategory] = []
        var didAdd = false
        
        for category in categories {
            if category.title == categoryTitle {
                let updatedTrackers = category.trackers + [tracker]
                let updatedCategory = TrackerCategory(title: category.title, trackers: updatedTrackers)
                newCategories.append(updatedCategory)
                didAdd = true
            } else {
                newCategories.append(category)
            }
        }
        
        if !didAdd {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            newCategories.append(newCategory)
        }
        categories = newCategories
    }
    
    func completeTracker(tracker: Tracker, for date: Date, wasAdded: (() -> Void)) {
        let trackerRecord = TrackerRecord(id: tracker.id, completionDate: date)
        if let index = completedTrackers.firstIndex(where: { $0.id == trackerRecord.id && calendar.isDate($0.completionDate, inSameDayAs: date) }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(trackerRecord)
        }
        wasAdded()
    }
}
