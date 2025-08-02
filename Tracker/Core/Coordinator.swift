//
//  Coordinator.swift
//  Tracker
//
//  Created by Михаил Бобылев on 26.07.2025.
//

import UIKit.UINavigationController

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
