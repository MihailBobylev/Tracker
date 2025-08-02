//
//  Int+Extension.swift
//  Tracker
//
//  Created by Михаил Бобылев on 02.08.2025.
//

import Foundation

extension Int {
    func daySuffix() -> String {
        let remainder10 = self % 10
        let remainder100 = self % 100

        if remainder100 >= 11 && remainder100 <= 14 {
            return "дней"
        }

        switch remainder10 {
        case 1:
            return "день"
        case 2...4:
            return "дня"
        default:
            return "дней"
        }
    }
}
