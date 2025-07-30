//
//  Collection+Extension.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
