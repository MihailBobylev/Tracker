//
//  UserDefaultsManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 23.08.2025.
//

import Foundation
final class UserDefaultsManager {
    private enum Keys: String {
        case appWasShown
    }
    
    static var appWasShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: Keys.appWasShown.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.appWasShown.rawValue)
        }
    }
}
