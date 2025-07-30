//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

protocol TrackersViewModelDelegate: AnyObject {
    func fillManagerWithData(trackersDataProvider: TrackersDataProvider)
    func updateCollectionView()
}

protocol TrackersViewModelProtocol {
    var delegate: TrackersViewModelDelegate? { get set }
    var trackersDataProvider: TrackersDataProvider { get }
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String)
}

final class TrackersViewModel: TrackersViewModelProtocol {
    var trackersDataProvider = TrackersDataProvider()
    
    weak var delegate: TrackersViewModelDelegate?
    
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String) {
        trackersDataProvider.addNewTracker(tracker, to: categoryTitle)
        delegate?.updateCollectionView()
    }
}

final class TrackersDataProvider {
    var categories: [TrackerCategory] = []
    
//    var categories: [TrackerCategory] = [
//        .init(title: "Домашний уют Домашний уют Домашний уют Домашний уют Домашний уют Домашний уют Домашний уют", trackers: [
//            .init(title: "Поливать растения Поливать растения Поливать растения Поливать растения Поливать растения", color: .green, emoji: "😪", schedule: []),
//            .init(title: "Смотреть аниме", color: .red, emoji: "😍", schedule: []),
//            .init(title: "Пинать балду", color: .blue, emoji: "👍", schedule: [])
//        ]),
//        .init(title: "Работа", trackers: [
//            .init(title: "Поливать растения", color: .green, emoji: "😪", schedule: []),
//            .init(title: "Смотреть аниме", color: .red, emoji: "😍", schedule: []),
//            .init(title: "Пинать балду", color: .blue, emoji: "👍", schedule: [])
//        ])
//    ]
    private var completedTrackers: [TrackerRecord] = []
    
    var addedIndexPath: IndexPath?
    
    func weekdayType(from date: Date) -> WeekdayType? {
        let weekday = Calendar.current.component(.weekday, from: date)
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
    
    func trackers(for date: Date) -> [TrackerCategory] {
        guard let weekday = weekdayType(from: date) else { return [] }
        
        return categories.compactMap { category in
            let filtered = category.trackers.filter { $0.schedule.contains(weekday) }
            return filtered.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filtered)
        }
    }
    
    func isCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        completedTrackers.contains { $0.id == tracker.id && Calendar.current.isDate($0.completionDate, inSameDayAs: date) }
    }
    
    func completedDays(for tracker: Tracker) -> Int {
        let trackerRecords = completedTrackers.filter { $0.id == tracker.id }
        let uniqueDates = Set(trackerRecords.map { Calendar.current.startOfDay(for: $0.completionDate) })
        return uniqueDates.count
    }
    
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String) {
        var newCategories: [TrackerCategory] = []
        var didAdd = false
        
        for (index, category) in categories.enumerated() {
            if category.title == categoryTitle {
                let updatedTrackers = category.trackers + [tracker]
                let updatedCategory = TrackerCategory(title: category.title, trackers: updatedTrackers)
                newCategories.append(updatedCategory)
                didAdd = true
                addedIndexPath = IndexPath(item: category.trackers.count, section: index)
            } else {
                newCategories.append(category)
            }
        }
        
        if !didAdd {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            newCategories.append(newCategory)
            addedIndexPath = IndexPath(item: 0, section: newCategories.count - 1)
        }
        categories = newCategories
    }
    
    func completeTracker(tracker: Tracker, for date: Date) {
        let trackerRecord = TrackerRecord(id: tracker.id, completionDate: date)
        if let index = completedTrackers.firstIndex(where: { $0.id == trackerRecord.id }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(trackerRecord)
        }
    }
}
