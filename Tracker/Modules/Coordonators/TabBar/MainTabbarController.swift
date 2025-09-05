//
//  MainTabbarController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit

// MARK: - TabBarPresentableCoordinator
protocol TabBarPresentableCoordinator: Coordinator {
    var tabBarItem: UITabBarItem { get }
}

final class MainTabbarController: UITabBarController {
    
    private var coordinators: [TabBarPresentableCoordinator] = []
    private let trackersDataProvider = TrackersDataProvider()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        UITabBar.appearance().backgroundColor = .backgroundWhite
        tabBar.addTopBorder(color: .sepLightGray)
        fillCoordinators()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fillCoordinators() {
        let trackersCoordinator = TrackersCoordinator(navigation: UINavigationController(), trackersDataProvider: trackersDataProvider)
        let statisticsCoordinator = StatisticsCoordinator(navigation: UINavigationController(), trackersDataProvider: trackersDataProvider)

        coordinators = [
            trackersCoordinator,
            statisticsCoordinator
        ]
        
        coordinators.forEach {
            $0.navigationController.tabBarItem = $0.tabBarItem
        }
        
        self.viewControllers = coordinators.map {
            $0.navigationController
        }
        coordinators.forEach { $0.start() }
    }
}
