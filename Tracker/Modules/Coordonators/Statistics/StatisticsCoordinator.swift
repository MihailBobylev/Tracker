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

    init(navigation: UINavigationController) {
        self.navigationController = navigation
    }
    
    func start() {
        navigationController.pushViewController(
            UIViewController(),
            animated: false
        )
    }
}
