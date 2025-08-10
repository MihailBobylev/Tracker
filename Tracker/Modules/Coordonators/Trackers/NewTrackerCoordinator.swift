//
//  NewTrackerCoordinator.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

final class NewTrackerCoordinator: Coordinator {
    private let newTrackerService = NewTrackerService()
    private let scheduleService = ScheduleService()
    private let trackersDataProvider: TrackersDataProvider
    private var newTrackerViewModel: NewTrackerViewModel?
    
    var onFinishCreatingTracker: ((Tracker, String) -> Void)?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, trackersDataProvider: TrackersDataProvider) {
        self.navigationController = navigationController
        self.trackersDataProvider = trackersDataProvider
    }
    
    func start() {
        navigationController.present(createNewTrackersController(), animated: true)
    }
    
    func goToCategory() {
        
    }
    
    func goToSchedule(selectedWeekdays: Set<WeekdayType>) {
        navigationController.presentedViewController?.present(
            createScheduleController(selectedWeekdays: selectedWeekdays),
            animated: true
        )
    }
    
    func didFinishCreatingNewTracker(_ tracker: Tracker, categoryTitle: String) {
        onFinishCreatingTracker?(tracker, categoryTitle)
        navigationController.dismiss(animated: true)
    }
}

private extension NewTrackerCoordinator {
    func createNewTrackersController() -> UIViewController {
        let viewModel = NewTrackerViewModel(newTrackerService: newTrackerService,
                                            coordinator: self,
                                            trackersDataProvider: trackersDataProvider)
        newTrackerViewModel = viewModel
        let viewController = NewTrackerViewController(viewModel: viewModel)
        return viewController
    }
    
    func createScheduleController(selectedWeekdays: Set<WeekdayType>) -> UIViewController {
        let viewModel = ScheduleViewModel(scheduleService: scheduleService, selectedWeekdays: selectedWeekdays, coordinator: self)
        viewModel.onDaysSelected = { [weak self] selectedWeekdays in
            self?.newTrackerViewModel?.updateSelectedWeekdays(selectedWeekdays)
        }
        let viewController = ScheduleViewController(viewModel: viewModel)
        return viewController
    }
}
