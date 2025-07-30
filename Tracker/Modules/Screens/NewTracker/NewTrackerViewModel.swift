//
//  NewTrackerViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

protocol NewTrackerViewModelDelegate: AnyObject {
    func updateScheduleInfo(with text: String?)
}

protocol NewTrackerViewModelProtocol {
    var delegate: NewTrackerViewModelDelegate? { get set }
    var onButtonStateChange: ((Bool) -> Void)? { get set }
    func getSections() -> [NewTrackerSectionType]
    func didSelectItem(at type: NewTrackerSectionType.Details)
    func updateSelectedWeekdays(_ days: Set<WeekdayType>)
    func updateEnteredText(newText: String)
    func doneButtonTapped()
}

final class NewTrackerViewModel: NewTrackerViewModelProtocol {
    private let coordinator: NewTrackerCoordinator
    private var newTrackerService: NewTrackerService
    private var trackerTitle: String = "" {
        didSet {
            updateButtonState()
        }
    }
    private var selectedWeekdays: Set<WeekdayType> = [] {
        didSet {
            delegate?.updateScheduleInfo(with: selectedWeekdays.labelText)
            updateButtonState()
        }
    }
    
    weak var delegate: NewTrackerViewModelDelegate?
    
    var onButtonStateChange: ((Bool) -> Void)?
    
    init(newTrackerService: NewTrackerService, coordinator: NewTrackerCoordinator) {
        self.newTrackerService = newTrackerService
        self.coordinator = coordinator
    }
    
    func getSections() -> [NewTrackerSectionType] {
        newTrackerService.fetchNewTrackerSections()
    }
    
    func didSelectItem(at type: NewTrackerSectionType.Details) {
        switch type {
        case .category:
            coordinator.goToCategory()
        case .schedule:
            coordinator.goToSchedule(selectedWeekdays: selectedWeekdays)
        }
    }
    
    func updateSelectedWeekdays(_ days: Set<WeekdayType>) {
        selectedWeekdays = days
    }
    
    func updateEnteredText(newText: String) {
        trackerTitle = newText
    }
    
    func doneButtonTapped() {
        let createdTracker = Tracker(title: trackerTitle,
                                     color: .green,
                                     emoji: "😍",
                                     schedule: selectedWeekdays)
        coordinator.didFinishCreatingNewTracker(createdTracker, categotyTitle: "Домашний уют")
    }
}

private extension NewTrackerViewModel {
    func updateButtonState() {
        let isEnabled = !trackerTitle.isEmpty && !selectedWeekdays.isEmpty
        onButtonStateChange?(isEnabled)
    }
}
