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
    private let categoriesDataProvider: CategoriesDataProvider
    private var newTrackerViewModel: NewTrackerViewModel?
    private var categoriesViewModel: CategoriesViewModel?
    
    var onFinishCreatingTracker: ((Tracker, String) -> Void)?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         trackersDataProvider: TrackersDataProvider,
         categoriesDataProvider: CategoriesDataProvider) {
        self.navigationController = navigationController
        self.trackersDataProvider = trackersDataProvider
        self.categoriesDataProvider = categoriesDataProvider
    }
    
    func start() {
        navigationController.present(createNewTrackersController(), animated: true)
    }
    
    func goToCategory(selectedCategory: TrackerCategory?) {
        navigationController.presentedViewController?.present(
            createCategoriesController(selectedCategory: selectedCategory),
            animated: true
        )
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
        let viewModel = ScheduleViewModel(scheduleService: scheduleService, selectedWeekdays: selectedWeekdays)
        viewModel.onDaysSelected = { [weak self] selectedWeekdays in
            guard let self else { return }
            newTrackerViewModel?.updateSelectedWeekdays(selectedWeekdays)
        }
        let viewController = ScheduleViewController(viewModel: viewModel)
        return viewController
    }
    
    func createCategoriesController(selectedCategory: TrackerCategory?) -> UIViewController {
        let viewModel = CategoriesViewModel(
            selectedCategory: selectedCategory,
            categoriesDataProvider: categoriesDataProvider
        )
        categoriesViewModel = viewModel
        
        let viewController = CategoriesViewController(viewModel: viewModel)
        
        viewModel.categorySelected = { [weak self] category in
            self?.newTrackerViewModel?.updateSelectedCategory(category: category)
        }
        
        viewModel.didTapAddNewCategory = { [weak self, weak viewController] in
            guard let viewController, let addCategoryVC = self?.createAddNewCategoryController() else { return }
            viewController.present(addCategoryVC, animated: true)
        }
        
        return viewController
    }
    
    func createAddNewCategoryController() -> UIViewController {
        let viewController = NewCategoryViewController()
        viewController.didTapAddNewCategory = { [weak self] name in
            self?.categoriesViewModel?.addNewCategory(name: name)
        }
        return viewController
    }
}
