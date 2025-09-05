//
//  EmptyStateType.swift
//  Tracker
//
//  Created by Михаил Бобылев on 05.09.2025.
//

import UIKit

enum EmptyStateType {
    case empty
    case notFound
    case none
    
    var image: UIImage? {
        return switch self {
        case .empty: .icRing
        case .notFound: .icNotFound
        case .none: nil
        }
    }
    
    var text: String {
        return switch self {
        case .empty: NSLocalizedString("what_are_we_going_to_track", comment: "Text displayed on empty state label")
        case .notFound: NSLocalizedString("nothing_was_found", comment: "Text displayed on not found state label")
        case .none: ""
        }
    }
}
