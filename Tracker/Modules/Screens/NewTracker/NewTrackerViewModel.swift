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
    var trackerEditMode: TrackerEditMode { get }
    var delegate: NewTrackerViewModelDelegate? { get set }
    func getSections() -> [NewTrackerSection]
    func configureTrackerCollectionViewManager(with collectionView: UICollectionView)
    func updateSelectedCategory(category: TrackerCategory?)
    func updateSelectedWeekdays(_ days: Set<WeekdayType>)
    func completedDaysCountForTracker(_ tracker: Tracker) -> Int 
    func doneButtonTapped()
}

final class NewTrackerViewModel: NewTrackerViewModelProtocol {
    private let coordinator: NewTrackerCoordinator
    private let newTrackerService: NewTrackerService
    private let trackersDataProvider: TrackersDataProvider
    
    private var mainCollectionViewManager: MainCollectionViewManagerProtocol?
    
    let trackerEditMode: TrackerEditMode
    
    private var editableTrackerState: TrackerEditableState
    weak var delegate: NewTrackerViewModelDelegate?
    
    init(newTrackerService: NewTrackerService,
         coordinator: NewTrackerCoordinator,
         trackersDataProvider: TrackersDataProvider,
         trackerEditMode: TrackerEditMode) {
        self.newTrackerService = newTrackerService
        self.coordinator = coordinator
        self.trackersDataProvider = trackersDataProvider
        self.trackerEditMode = trackerEditMode
        
        if let tracker = trackerEditMode.editableTracker {
            let category = trackersDataProvider.getCategory(for: tracker)
            self.editableTrackerState = TrackerEditableState(tracker: tracker,
                                                             category: category)
        } else {
            self.editableTrackerState = TrackerEditableState(tracker: nil, category: nil)
        }
    }
    
    func configureTrackerCollectionViewManager(with collectionView: UICollectionView) {
        mainCollectionViewManager = MainCollectionViewManager(trackersDataProvider: trackersDataProvider,
                                                              collectionView: collectionView,
                                                              sections: newTrackerService.fetchNewTrackerSections(),
                                                              editableTracker: editableTrackerState)
        mainCollectionViewManager?.setupCollectionView()
        mainCollectionViewManager?.delegate = self
    }
    
    func getSections() -> [NewTrackerSection] {
        newTrackerService.fetchNewTrackerSections()
    }
    
    func updateSelectedWeekdays(_ days: Set<WeekdayType>) {
        editableTrackerState.weekdays = days
        mainCollectionViewManager?.updateEditableTracker(with: editableTrackerState)
        updateScheduleInfo()
        updateButtonState()
    }
    
    func doneButtonTapped() {
        guard !editableTrackerState.title.isEmpty,
              let color = editableTrackerState.color,
              !editableTrackerState.emoji.isEmpty,
              !editableTrackerState.weekdays.isEmpty,
              let category = editableTrackerState.category else { return }
        
        let createdTracker = Tracker(
            id: editableTrackerState.id,
            title: editableTrackerState.title,
            color: color,
            emoji: editableTrackerState.emoji,
            schedule: editableTrackerState.weekdays)
        coordinator.didFinishCreatingNewTracker(createdTracker, categoryTitle: category.title)
    }
    
    func completedDaysCountForTracker(_ tracker: Tracker) -> Int {
        trackersDataProvider.completedDays(for: tracker)
    }
}

extension NewTrackerViewModel: MainCollectionViewManagerDelegate {
    func didSelectItem(at type: NewTrackerSection, indexPath: IndexPath) {
        switch type {
        case let type as DetailsSection:
            let subItem = type.models[indexPath.item]
            switch subItem {
            case .category:
                coordinator.goToCategory(selectedCategory: editableTrackerState.category)
            case .schedule:
                coordinator.goToSchedule(selectedWeekdays: editableTrackerState.weekdays)
            }
        default:
            break
        }
    }
    
    func updateEnteredText(newText: String) {
        editableTrackerState.title = newText
        mainCollectionViewManager?.updateEditableTracker(with: editableTrackerState)
        updateButtonState()
    }
    
    func updateSelectedCategory(category: TrackerCategory?) {
        editableTrackerState.category = category
        mainCollectionViewManager?.updateEditableTracker(with: editableTrackerState)
        updateSelectedCategoryInfo()
        updateButtonState()
    }
    
    func updateSelectedEmoji(emoji: String) {
        editableTrackerState.emoji = emoji
        mainCollectionViewManager?.updateEditableTracker(with: editableTrackerState)
        updateButtonState()
    }
    
    func updateSelectedColor(color: UIColor) {
        editableTrackerState.color = color
        mainCollectionViewManager?.updateEditableTracker(with: editableTrackerState)
        updateButtonState()
    }
}

private extension NewTrackerViewModel {
    func updateSelectedCategoryInfo() {
        mainCollectionViewManager?.updateSelectedCategory()
    }
    
    func updateScheduleInfo() {
        mainCollectionViewManager?.updateSelectedWeekday()
    }
    
    func updateButtonState() {
        guard !editableTrackerState.title.isEmpty,
              let _ = editableTrackerState.color,
              !editableTrackerState.emoji.isEmpty,
              !editableTrackerState.weekdays.isEmpty,
              let _ = editableTrackerState.category else {
            delegate?.changeButtonState(to: false)
            return
        }
        
        delegate?.changeButtonState(to: true)
    }
}
