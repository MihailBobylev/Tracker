//
//  TrackersDataProvider.swift
//  Tracker
//
//  Created by Михаил Бобылев on 31.07.2025.
//

import Foundation

protocol TrackersDataProviderDelegate: AnyObject {
    func updateCollection(didUpdate update: TrackerStoreUpdate?)
}

final class TrackersDataProvider {
    private let calendar = Calendar.current
    private let trackerRecordStore = TrackerRecordStore()
    
    lazy var trackerStore: TrackerStore = {
        let store = TrackerStore()
        store.delegate = self
        return store
    }()
    
    weak var delegate: TrackersDataProviderDelegate?
    
    func trackers(for date: Date, searchText: String?) {
        guard let weekday = calendar.weekdayType(from: date) else {
            return
        }
        trackerStore.reconfigureFetchedResultsController(for: weekday, searchText: searchText)
    }

    func tracker(from coreData: TrackerCoreData) -> Tracker? {
        trackerStore.tracker(from: coreData)
    }
    
    func isCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        trackerRecordStore.isTrackerCompleted(tracker, on: date)
    }
    
    func completedDays(for tracker: Tracker) -> Int {
        trackerRecordStore.completionCount(for: tracker)
    }
    
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String) {
        try? trackerStore.addTracker(tracker, to: categoryTitle)
    }
    
    func completeTracker(tracker: Tracker, for date: Date) {
        try? trackerRecordStore.toggleRecord(for: tracker, on: date)
    }
}

extension TrackersDataProvider: TrackerStoreDelegate {
    func store(didUpdate update: TrackerStoreUpdate?) {
        delegate?.updateCollection(didUpdate: update)
    }
}
