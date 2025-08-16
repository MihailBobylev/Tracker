//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

protocol TrackersViewModelDelegate: AnyObject {
    func updateEmptyState(to isShow: Bool)
}

protocol TrackersViewModelProtocol {
    var selectedDate: Date { get set }
    var delegate: TrackersViewModelDelegate? { get set }
    func configureTrackerCollectionViewManager(with collectionView: UICollectionView)
    func goToAddNewTrackerScreen()
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String)
}

final class TrackersViewModel: TrackersViewModelProtocol {
    private let coordinator: TrackersCoordinator
    private let trackersDataProvider: TrackersDataProvider
    private let calendar = Calendar.current
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    private var trackerCollectionViewManager: TrackerCollectionViewManagerProtocol?
    
    var selectedDate = Date() {
        didSet {
            updateDate(newDate: selectedDate)
            updateTrackers(for: selectedDate)
        }
    }
    weak var delegate: TrackersViewModelDelegate?
    
    init(coordinator: TrackersCoordinator, trackersDataProvider: TrackersDataProvider) {
        self.coordinator = coordinator
        self.trackersDataProvider = trackersDataProvider
        self.trackersDataProvider.delegate = self
    }
    
    func configureTrackerCollectionViewManager(with collectionView: UICollectionView) {
        trackerCollectionViewManager = TrackerCollectionViewManager(selectedDate: selectedDate,
                                                                    trackersDataProvider: trackersDataProvider,
                                                                    collectionView: collectionView)
        trackerCollectionViewManager?.delegate = self
        trackerCollectionViewManager?.setupCollectionView()
    }
    
    func goToAddNewTrackerScreen() {
        coordinator.createAddNewTrackerController()
    }
    
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String) {
        trackersDataProvider.addNewTracker(tracker, to: categoryTitle)
        updateTrackers(for: selectedDate)
    }
}

extension TrackersViewModel: TrackerCollectionViewManagerProtocolDelegate {
    func completeTracker(tracker: Tracker, indexPath: IndexPath) {
        guard !calendar.isDateInFuture(selectedDate) else {
            feedbackGenerator.prepare()
            feedbackGenerator.notificationOccurred(.error)
            return
        }
        trackersDataProvider.completeTracker(tracker: tracker, for: selectedDate)
    }
}

extension TrackersViewModel: TrackersDataProviderDelegate {
    func updateCollection(didUpdate update: TrackerStoreUpdate?) {
        trackerCollectionViewManager?.updateCollectionView(didUpdate: update)
        delegate?.updateEmptyState(to: trackersDataProvider.trackerStore.fetchedResultsController?.sections?.isEmpty ?? true)
    }
}

private extension TrackersViewModel {
    func updateDate(newDate: Date) {
        trackerCollectionViewManager?.updateDate(newDate: newDate)
    }
    
    func updateTrackers(for date: Date) {
        trackersDataProvider.trackers(for: date)
        delegate?.updateEmptyState(to: trackersDataProvider.trackerStore.fetchedResultsController?.sections?.isEmpty ?? true)
    }
}
