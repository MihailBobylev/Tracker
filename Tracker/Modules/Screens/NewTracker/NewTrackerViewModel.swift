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
    func getSections() -> [NewTrackerSection]
    func configureTrackerCollectionViewManager(with collectionView: UICollectionView)
    func updateSelectedCategory(category: TrackerCategory?)
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
    
    private var selectedCategory: TrackerCategory? {
        didSet {
            updateSelectedCategoryInfo(with: selectedCategory?.title)
            updateButtonState()
        }
    }
    
    private var selectedWeekdays: Set<WeekdayType> = [] {
        didSet {
            updateScheduleInfo(with: selectedWeekdays.labelText)
            updateButtonState()
        }
    }
    private var trackerEmoji: String = "" {
        didSet {
            updateButtonState()
        }
    }
    
    private var trackerColor: UIColor? {
        didSet {
            updateButtonState()
        }
    }
    
    weak var delegate: NewTrackerViewModelDelegate?
    
    init(newTrackerService: NewTrackerService, coordinator: NewTrackerCoordinator, trackersDataProvider: TrackersDataProvider) {
        self.newTrackerService = newTrackerService
        self.coordinator = coordinator
        self.trackersDataProvider = trackersDataProvider
    }
    
    func configureTrackerCollectionViewManager(with collectionView: UICollectionView) {
        mainCollectionViewManager = MainCollectionViewManager(trackersDataProvider: trackersDataProvider,
                                                              collectionView: collectionView,
                                                              sections: newTrackerService.fetchNewTrackerSections())
        mainCollectionViewManager?.setupCollectionView()
        mainCollectionViewManager?.delegate = self
    }
    
    func getSections() -> [NewTrackerSection] {
        newTrackerService.fetchNewTrackerSections()
    }
    
    func updateSelectedWeekdays(_ days: Set<WeekdayType>) {
        selectedWeekdays = days
    }

    func doneButtonTapped() {
        guard let selectedCategory, let color = trackerColor else { return }
        let createdTracker = Tracker(title: trackerTitle,
                                     color: color,
                                     emoji: trackerEmoji,
                                     schedule: selectedWeekdays)
        coordinator.didFinishCreatingNewTracker(createdTracker, categoryTitle: selectedCategory.title)
    }
}

extension NewTrackerViewModel: MainCollectionViewManagerDelegate {
    func didSelectItem(at type: NewTrackerSection, indexPath: IndexPath) {
        switch type {
        case let type as DetailsSection:
            let subItem = type.models[indexPath.item]
            switch subItem {
            case .category:
                coordinator.goToCategory(selectedCategory: selectedCategory)
            case .schedule:
                coordinator.goToSchedule(selectedWeekdays: selectedWeekdays)
            }
        default:
            break
        }
    }
    
    func updateEnteredText(newText: String) {
        trackerTitle = newText
    }
    
    func updateSelectedCategory(category: TrackerCategory?) {
        selectedCategory = category
    }
    
    func updateSelectedEmoji(emoji: String) {
        trackerEmoji = emoji
    }
    
    func updateSelectedColor(color: UIColor) {
        trackerColor = color
    }
}

private extension NewTrackerViewModel {
    func updateSelectedCategoryInfo(with text: String?) {
        mainCollectionViewManager?.updateSelectedCategory(with: text)
    }
    
    func updateScheduleInfo(with text: String?) {
        mainCollectionViewManager?.updateSelectedWeekday(with: text)
    }
    
    func updateButtonState() {
        let isEnabled = !trackerTitle.isEmpty
        && selectedCategory != nil
        && !selectedWeekdays.isEmpty
        && !trackerEmoji.isEmpty
        && trackerColor != nil
        delegate?.changeButtonState(to: isEnabled)
    }
}
