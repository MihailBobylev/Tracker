//
//  ScheduleViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

protocol ScheduleViewModelDelegate: AnyObject {
    func closeController()
}

protocol ScheduleViewModelProtocol {
    var delegate: ScheduleViewModelDelegate? { get set }
    func getSections() -> [WeekdayType]
    func getSelectedWeekdays() -> Set<WeekdayType>
    func didSelectItem(weekdayType: WeekdayType)
    func doneButtonTapped()
}

final class ScheduleViewModel: ScheduleViewModelProtocol {
    private let coordinator: NewTrackerCoordinator
    private var scheduleService: ScheduleService
    private var selectedWeekdays: Set<WeekdayType>
    
    weak var delegate: ScheduleViewModelDelegate?
    
    var onDaysSelected: ((Set<WeekdayType>) -> Void)?
    
    init(scheduleService: ScheduleService, selectedWeekdays: Set<WeekdayType>, coordinator: NewTrackerCoordinator) {
        self.scheduleService = scheduleService
        self.selectedWeekdays = selectedWeekdays
        self.coordinator = coordinator
    }
    
    func getSections() -> [WeekdayType] {
        scheduleService.fetchSchedule()
    }
    
    func getSelectedWeekdays() -> Set<WeekdayType> {
        selectedWeekdays
    }
    
    func didSelectItem(weekdayType: WeekdayType) {
        if selectedWeekdays.contains(weekdayType) {
            selectedWeekdays.remove(weekdayType)
        } else {
            selectedWeekdays.insert(weekdayType)
        }
    }
    
    func doneButtonTapped() {
        onDaysSelected?(selectedWeekdays)
        delegate?.closeController()
    }
}
