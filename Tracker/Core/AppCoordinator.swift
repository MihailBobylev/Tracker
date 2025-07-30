//
//  AppCoordinator.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit

final class AppCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var window: UIWindow?
    var deepLink: String?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        window?.rootViewController = navigationController
        startMainFlow()
    }
    
    func startMainFlow() {
        let tabBarCoordinator = MainTabbarController()
        window?.rootViewController = tabBarCoordinator
    }
}
