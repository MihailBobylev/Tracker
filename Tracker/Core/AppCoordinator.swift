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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        window?.rootViewController = navigationController
        guard UserDefaultsManager.appWasShown else {
            starOnboardingFlow()
            return
        }
        startMainFlow()
    }
    
    func starOnboardingFlow() {
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.didTapDone = { [weak self] in
            guard let self else { return }
            startMainFlow()
        }
        window?.rootViewController = onboardingViewController
    }
    
    func startMainFlow() {
        let tabBarCoordinator = MainTabbarController()
        window?.rootViewController = tabBarCoordinator
    }
}
