//
//  TrackersCoordinator.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit

final class TrackersCoordinator: TabBarPresentableCoorinator {
    private var trackerViewModel: TrackersViewModel?
    private let trackersDataProvider = TrackersDataProvider()
    
    var tabBarItem: UITabBarItem = {
        var icon = UIImage(resource: .icTrackerSelected)
        let unselected = UIImage(resource: .icTrackerUnselected)
        let title = "Трекеры"
        let item = UITabBarItem(title: title, image: unselected, selectedImage: icon)
        return item
    }()
    
    var navigationController: UINavigationController

    init(navigaton: UINavigationController) {
        self.navigationController = navigaton
    }
    
    func start() {
        navigationController.pushViewController(
            createTrackersController(),
            animated: false
        )
    }
    
    func createAddNewTrackerController() {
        let newTrackerCoordinator = NewTrackerCoordinator(
            navigationController: navigationController,
            trackersDataProvider: trackersDataProvider
        )
        newTrackerCoordinator.onFinishCreatingTracker = { [weak self] newTracker, categotyTitle in
            self?.trackerViewModel?.addNewTracker(newTracker, to: categotyTitle)
        }
        newTrackerCoordinator.start()
    }
}

private extension TrackersCoordinator {
    func createTrackersController() -> UIViewController {
        let viewModel = TrackersViewModel(coordinator: self,
                                          trackersDataProvider: trackersDataProvider)
        trackerViewModel = viewModel
        let viewController = TrackersViewController(viewModel: viewModel)
        return viewController
    }
    
    
}
