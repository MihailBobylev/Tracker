//
//  TrackersViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

protocol TrackersViewModelDelegate: AnyObject {
    func updateEmptyState(to type: EmptyStateType)
}

protocol TrackersViewModelProtocol {
    var selectedDate: Date { get set }
    var searchedText: String { get set }
    var delegate: TrackersViewModelDelegate? { get set }
    func configureTrackerCollectionViewManager(with collectionView: UICollectionView)
    func goToAddNewTrackerScreen()
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String)
    func screenWasOpenedMetrica()
    func screenWasClosedMetrica()
}

final class TrackersViewModel: TrackersViewModelProtocol {
    private struct Constants {
        static var metricaScreenName = "Main"
    }
    
    private let coordinator: TrackersCoordinator
    private let trackersDataProvider: TrackersDataProvider
    private let analyticsService: AnalyticsService
    private let calendar = Calendar.current
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    private var trackerCollectionViewManager: TrackerCollectionViewManagerProtocol?
    
    var selectedDate = Date() {
        didSet {
            updateDate(newDate: selectedDate)
            updateTrackers(for: selectedDate, text: searchedText)
        }
    }
    
    var searchedText: String = "" {
        didSet {
            updateTrackers(for: selectedDate, text: searchedText)
        }
    }
    weak var delegate: TrackersViewModelDelegate?
    
    init(coordinator: TrackersCoordinator, trackersDataProvider: TrackersDataProvider, analyticsService: AnalyticsService) {
        self.coordinator = coordinator
        self.analyticsService = analyticsService
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
        addTrackerMetrica()
        coordinator.createAddNewTrackerController()
    }
    
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String) {
        trackersDataProvider.addNewTracker(tracker, to: categoryTitle)
        updateTrackers(for: selectedDate, text: searchedText)
    }
}

// MARK: Metrica
extension TrackersViewModel {
    func screenWasOpenedMetrica() {
        let metricaModel = MetricaModel(event: .open, screen: Constants.metricaScreenName, item: .none)
        reportMetrica(model: metricaModel)
    }
    
    func screenWasClosedMetrica() {
        let metricaModel = MetricaModel(event: .close, screen: Constants.metricaScreenName, item: .none)
        reportMetrica(model: metricaModel)
    }
    
    func addTrackerMetrica() {
        let metricaModel = MetricaModel(event: .click, screen: Constants.metricaScreenName, item: .addTrack)
        reportMetrica(model: metricaModel)
    }
    
    func completeTrackerMetrica() {
        let metricaModel = MetricaModel(event: .click, screen: Constants.metricaScreenName, item: .track)
        reportMetrica(model: metricaModel)
    }
    
    func openFiltersMetrica() {
        let metricaModel = MetricaModel(event: .click, screen: Constants.metricaScreenName, item: .filter)
        reportMetrica(model: metricaModel)
    }
    
    func editTrackerMetrica() {
        let metricaModel = MetricaModel(event: .click, screen: Constants.metricaScreenName, item: .edit)
        reportMetrica(model: metricaModel)
    }
    
    func deleteTrakerMetrica() {
        let metricaModel = MetricaModel(event: .click, screen: Constants.metricaScreenName, item: .delete)
        reportMetrica(model: metricaModel)
    }
    
    func reportMetrica(model: MetricaModel) {
        analyticsService.report(model: model)
    }
}

extension TrackersViewModel: TrackerCollectionViewManagerProtocolDelegate {
    func completeTracker(tracker: Tracker, indexPath: IndexPath) {
        guard !calendar.isDateInFuture(selectedDate) else {
            feedbackGenerator.prepare()
            feedbackGenerator.notificationOccurred(.error)
            return
        }
        completeTrackerMetrica()
        trackersDataProvider.completeTracker(tracker: tracker, for: selectedDate)
        NotificationCenter.default.post(name: .trackerComplete, object: self)
    }
}

extension TrackersViewModel: TrackersDataProviderDelegate {
    func updateCollection(didUpdate update: TrackerStoreUpdate?) {
        trackerCollectionViewManager?.updateCollectionView(didUpdate: update)
    }
}

private extension TrackersViewModel {
    func updateDate(newDate: Date) {
        trackerCollectionViewManager?.updateDate(newDate: newDate)
    }
    
    func updateTrackers(for date: Date, text: String) {
        trackersDataProvider.trackers(for: date, searchText: text)
        let fetchedSectionsIsEmpty = trackersDataProvider.trackerStore.fetchedResultsController?.sections?.isEmpty ?? true
        if fetchedSectionsIsEmpty && text.isEmpty {
            delegate?.updateEmptyState(to: .empty)
        } else if fetchedSectionsIsEmpty && !text.isEmpty {
            delegate?.updateEmptyState(to: .notFound)
        } else {
            delegate?.updateEmptyState(to: .none)
        }
    }
}
