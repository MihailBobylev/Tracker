//
//  StatisticsCoordinator.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit

final class StatisticsCoordinator: TabBarPresentableCoordinator {
    var tabBarItem: UITabBarItem = {
        var icon = UIImage(resource: .icStatisticsSelected)
        let unselected = UIImage(resource: .icStatisticsUnselected)
        let title = NSLocalizedString("statistics", comment: "title text")
        let item = UITabBarItem(title: title, image: unselected, selectedImage: icon)
        return item
    }()
    
    var navigationController: UINavigationController
    private let trackersDataProvider: TrackersDataProvider
    
    init(navigation: UINavigationController, trackersDataProvider: TrackersDataProvider) {
        self.navigationController = navigation
        self.trackersDataProvider = trackersDataProvider
    }
    
    func start() {
        navigationController.pushViewController(
            createStatisticsController(),
            animated: false
        )
    }
}

private extension StatisticsCoordinator {
    func createStatisticsController() -> UIViewController {
        let viewModel = StatisticsViewModel(trackersDataProvider: trackersDataProvider)
        let viewController = StatisticsViewController(viewModel: viewModel)
        return viewController
    }
}
