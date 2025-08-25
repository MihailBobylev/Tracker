//
//  AccessoryType.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

enum AccessoryType {
    case chevron
    case checkmark(isSelected: Bool)
    case switcher(isOn: Bool)
    case none
    
    var image: UIImage? {
        return switch self {
        case .chevron: .icArrowRightGray
        case .checkmark: .icCheckBlue
        default: nil
        }
    }
}
