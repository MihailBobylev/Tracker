//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

protocol NewTrackerViewModelDelegate: AnyObject {
    func changeButtonState(to isEnabled: Bool)
}

protocol NewTrackerViewModelProtocol {
    var delegate: NewTrackerViewModelDelegate? { get set }
    func getSections() -> [NewTrackerSectionType]
    func configureTrackerCollectonViewManager(with collectionView: UICollectionView)
    func updateSelectedWeekdays(_ days: Set<WeekdayType>)
    func doneButtonTapped()
}

final class NewTrackerViewModel: NewTrackerViewModelProtocol {
    private let coordinator: NewTrackerCoordinator
    private var newTrackerService: NewTrackerService
    private let trackersDataProvider: TrackersDataProvider
    private var mainCollectionViewManager: MainCollectionViewManagerProtocol?
    private var trackerTitle: String = "" {
        didSet {
            updateButtonState()
        }
    }
    private var selectedWeekdays: Set<WeekdayType> = [] {
        didSet {
            updateScheduleInfo(with: selectedWeekdays.labelText)
            updateButtonState()
        }
    }
    
    weak var delegate: NewTrackerViewModelDelegate?
    
    init(newTrackerService: NewTrackerService, coordinator: NewTrackerCoordinator, trackersDataProvider: TrackersDataProvider) {
        self.newTrackerService = newTrackerService
        self.coordinator = coordinator
        self.trackersDataProvider = trackersDataProvider
    }
    
    func configureTrackerCollectonViewManager(with collectionView: UICollectionView) {
        mainCollectionViewManager = MainCollectionViewManager(trackersDataProvider: trackersDataProvider,
                                                              collectionView: collectionView,
                                                              sections: newTrackerService.fetchNewTrackerSections())
        mainCollectionViewManager?.setupCollectionView()
        mainCollectionViewManager?.delegate = self
    }
    
    func getSections() -> [NewTrackerSectionType] {
        newTrackerService.fetchNewTrackerSections()
    }
    
    func updateSelectedWeekdays(_ days: Set<WeekdayType>) {
        selectedWeekdays = days
    }

    func doneButtonTapped() {
        let createdTracker = Tracker(title: trackerTitle,
                                     color: .green,
                                     emoji: "😍",
                                     schedule: selectedWeekdays)
        coordinator.didFinishCreatingNewTracker(createdTracker, categotyTitle: "Домашний уют")
    }
}

extension NewTrackerViewModel: MainCollectionViewManagerDelegate {
    func didSelectItem(at type: NewTrackerSectionType.Details) {
        switch type {
        case .category:
            coordinator.goToCategory()
        case .schedule:
            coordinator.goToSchedule(selectedWeekdays: selectedWeekdays)
        }
    }
    
    func updateEnteredText(newText: String) {
        trackerTitle = newText
    }
}

private extension NewTrackerViewModel {
    func updateScheduleInfo(with text: String?) {
        mainCollectionViewManager?.updateSelectedWeekday(with: text)
    }
    
    func updateButtonState() {
        let isEnabled = !trackerTitle.isEmpty && !selectedWeekdays.isEmpty
        delegate?.changeButtonState(to: isEnabled)
    }
}
