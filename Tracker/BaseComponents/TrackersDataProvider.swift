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
    private let trackerRecordStore = TrackerRecordStore()
    
    lazy var trackerStore: TrackerStore = {
        let store = TrackerStore()
        store.delegate = self
        return store
    }()
    
    weak var delegate: TrackersDataProviderDelegate?
    
    func trackers(for date: Date, filterType: FilterMode, searchText: String?) {
        trackerStore.reconfigureFetchedResultsController(for: date,
                                                         searchText: searchText,
                                                         filterType: filterType)
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
    
    func completedTrackersCount() -> Int {
        trackerRecordStore.completedTrackersCount()
    }
    
    func addOrUpdateTracker(_ tracker: Tracker, to categoryTitle: String) {
        try? trackerStore.addOrUpdateTracker(tracker, to: categoryTitle)
    }
    
    func completeTracker(tracker: Tracker, for date: Date) {
        try? trackerRecordStore.toggleRecord(for: tracker, on: date)
    }
    
    func deleteTracker(_ tracker: Tracker) {
        try? trackerStore.deleteTracker(by: tracker.id)
    }
    
    func getCategory(for tracker: Tracker) -> TrackerCategory? {
        try? trackerStore.getTrackerCategory(by: tracker.id)
    }
}

extension TrackersDataProvider: TrackerStoreDelegate {
    func store(didUpdate update: TrackerStoreUpdate?) {
        delegate?.updateCollection(didUpdate: update)
    }
}
