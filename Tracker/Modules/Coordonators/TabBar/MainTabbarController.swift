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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        UITabBar.appearance().backgroundColor = #colorLiteral(red: 0.9843137255, green: 0.9882352941, blue: 0.9960784314, alpha: 1)
        tabBar.addTopBorder(color: .lightGray)
        fillCoordinators()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fillCoordinators() {
        let trackersCoordinator = TrackersCoordinator(navigation: UINavigationController())
        let statisticsCoordinator = StatisticsCoordinator(navigation: UINavigationController())

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
