//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        appCoordinator = AppCoordinator(navigationController: UINavigationController())
        window?.rootViewController = appCoordinator?.navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator?.window = window
        appCoordinator?.start()
    }
}

