//
//  NewTrackerSectionType.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import UIKit

enum NewTrackerSectionType {
    case titleTextField
    case details
    case emoji
    case customColor
}

protocol NewTrackerSection {
    var sectionID: String { get }
    var sectionType: NewTrackerSectionType { get }
    var sectionTitle: String? { get }
    var numberOfItems: Int { get }
}

struct TextFieldSection: NewTrackerSection {
    var sectionID: String { "\(sectionType)" }
    var sectionType: NewTrackerSectionType
    var sectionTitle: String?
    var numberOfItems: Int { 1 }
}

struct DetailsSection: NewTrackerSection {
    var sectionID: String { "\(sectionType)" }
    var sectionType: NewTrackerSectionType
    var sectionTitle: String?
    var numberOfItems: Int { models.count }
    var models: [Details]
    
    enum Details {
        case category
        case schedule
        
        var title: String {
            switch self {
            case .category:
                return NSLocalizedString("category", comment: "category section title text")
            case .schedule:
                return NSLocalizedString("schedule", comment: "schedule section title text")
            }
        }
    }
}

struct EmojiSection: NewTrackerSection {
    var sectionID: String { "\(sectionType)" }
    var sectionType: NewTrackerSectionType
    var sectionTitle: String?
    var numberOfItems: Int { models.count }
    let models: [Emoji]
    
    struct Emoji {
        let emoji: String
    }
}

struct ColorsSection: NewTrackerSection {
    var sectionID: String { "\(sectionType)" }
    var sectionType: NewTrackerSectionType
    var sectionTitle: String?
    var numberOfItems: Int { models.count }
    let models: [CustomColor]
    
    struct CustomColor {
        let color: UIColor
    }
}
