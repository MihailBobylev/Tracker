//
//  TrackersCoordinator.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit

final class TrackersCoordinator: TabBarPresentableCoordinator {
    private var trackerViewModel: TrackersViewModel?
    private let trackersDataProvider: TrackersDataProvider
    private let categoriesDataProvider = CategoriesDataProvider()
    private let analyticsService = AnalyticsService()
    
    var tabBarItem: UITabBarItem = {
        var icon = UIImage(resource: .icTrackerSelected)
        let unselected = UIImage(resource: .icTrackerUnselected)
        let title = NSLocalizedString("trackers", comment: "Text displayed on title")
        let item = UITabBarItem(title: title, image: unselected, selectedImage: icon)
        return item
    }()
    
    var navigationController: UINavigationController

    init(navigation: UINavigationController, trackersDataProvider: TrackersDataProvider) {
        self.navigationController = navigation
        self.trackersDataProvider = trackersDataProvider
    }
    
    func start() {
        navigationController.pushViewController(
            createTrackersController(),
            animated: false
        )
    }
    
    func createAddNewTrackerController(trackerEditMode: TrackerEditMode) {
        let newTrackerCoordinator = NewTrackerCoordinator(
            navigationController: navigationController,
            trackersDataProvider: trackersDataProvider,
            categoriesDataProvider: categoriesDataProvider,
            trackerEditMode: trackerEditMode
        )
        newTrackerCoordinator.onFinishCreatingTracker = { [weak self] newTracker, categoryTitle in
            self?.trackerViewModel?.addNewTracker(newTracker, to: categoryTitle)
        }
        newTrackerCoordinator.start()
    }
}

private extension TrackersCoordinator {
    func createTrackersController() -> UIViewController {
        let viewModel = TrackersViewModel(coordinator: self,
                                          trackersDataProvider: trackersDataProvider,
                                          analyticsService: analyticsService)
        trackerViewModel = viewModel
        let viewController = TrackersViewController(viewModel: viewModel)
        return viewController
    }
}
