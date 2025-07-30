//
//  TrackersCoordinator.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit

final class TrackersCoordinator: TabBarPresentableCoorinator {
    private var trackerViewModel: TrackersViewModel?
    
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
}

private extension TrackersCoordinator {
    func createTrackersController() -> UIViewController {
        let viewModel = TrackersViewModel()
        trackerViewModel = viewModel
        let viewController = TrackersViewController(viewModel: viewModel)
        viewController.addNewTracker = { [weak self] in
            guard let self else { return }
            createAddNewTrackerController()
        }
        
        return viewController
    }
    
    func createAddNewTrackerController() {
        let newTrackerCoordinator = NewTrackerCoordinator(
            navigationController: navigationController
        )
        newTrackerCoordinator.onFinishCreatingTracker = { [weak self] newTracker, categotyTitle in
            //self?.trackerViewModel?.addNewTracker(newTrackerData)
            self?.trackerViewModel?.addNewTracker(newTracker, to: categotyTitle)
        }
        newTrackerCoordinator.start()
    }
}
