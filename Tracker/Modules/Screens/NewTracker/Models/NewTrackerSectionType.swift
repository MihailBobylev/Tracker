//
//  NewTrackerSectionType.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

enum NewTrackerSectionType {
    case titleTextField
    case details([Details])
    
    var numberOfItemsInSection: Int {
        switch self {
        case .titleTextField:
            return 1
        case let .details(details):
            return details.count
        }
    }
    
    enum Details {
        case category(subtitle: String?)
        case schedule(subtitle: String?)
        
        var title: String {
            switch self {
            case .category:
                return "Категория"
            case .schedule:
                return "Расписание"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .category(let subtitle), .schedule(let subtitle):
                return subtitle
            }
        }
    }
}
