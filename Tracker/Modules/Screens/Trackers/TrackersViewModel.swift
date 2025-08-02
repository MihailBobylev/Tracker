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
    func configureTrackerCollectonViewManager(with collectionView: UICollectionView)
    func goToAddNewTrackerScreen()
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String)
}

final class TrackersViewModel: TrackersViewModelProtocol {
    private let coordinator: TrackersCoordinator
    private let trackersDataProvider: TrackersDataProvider
    private let calendar = Calendar.current
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    private var trackerCollectonViewManager: TrackerCollectonViewManagerProtocol?
    
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
        setupResponsibilities()
    }
    
    func configureTrackerCollectonViewManager(with collectionView: UICollectionView) {
        trackerCollectonViewManager = TrackerCollectonViewManager(trackersDataProvider: trackersDataProvider,
                                                                  collectionView: collectionView)
        trackerCollectonViewManager?.delegate = self
        trackerCollectonViewManager?.setupCollectionView()
    }
    
    func goToAddNewTrackerScreen() {
        coordinator.createAddNewTrackerController()
    }
    
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String) {
        trackersDataProvider.addNewTracker(tracker, to: categoryTitle)
        updateTrackers(for: selectedDate)
    }
    
    private func updateTrackers(for date: Date) {
        trackersDataProvider.trackers(for: date)
    }
}

extension TrackersViewModel: TrackerCollectonViewManagerProtocolDelegate {
    func completeTracker(tracker: Tracker, indexPath: IndexPath) {
        guard !calendar.isDateInFuture(selectedDate) else {
            feedbackGenerator.prepare()
            feedbackGenerator.notificationOccurred(.error)
            return
        }
        trackerCollectonViewManager?.completeTracker(tracker: tracker, for: selectedDate, indexPath: indexPath)
    }
}

private extension TrackersViewModel {
    func setupResponsibilities() {
        trackersDataProvider.categoriesChanged = { [weak self] isEmpty in
            guard let self else { return }
            trackerCollectonViewManager?.updateCollectionView()
            delegate?.updateEmptyState(to: isEmpty)
        }
    }
    
    func updateDate(newDate: Date) {
        trackerCollectonViewManager?.updateDate(newDate: newDate)
    }
}
