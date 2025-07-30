//
//  StatisticsCoordinator.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit

final class StatisticsCoordinator: TabBarPresentableCoorinator {
    var tabBarItem: UITabBarItem = {
        var icon = UIImage(resource: .icStatisticsSelected)
        let unselected = UIImage(resource: .icStatisticsUnselected)
        let title = "Статистика"
        let item = UITabBarItem(title: title, image: unselected, selectedImage: icon)
        return item
    }()
    
    var navigationController: UINavigationController

    init(navigaton: UINavigationController) {
        self.navigationController = navigaton
    }
    
    func start() {
        navigationController.pushViewController(
            UIViewController(),
            animated: false
        )
    }
}
