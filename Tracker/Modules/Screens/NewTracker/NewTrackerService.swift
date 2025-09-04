//
//  NewTrackerManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//


import Foundation
import UIKit

final class NewTrackerService {
    
    func fetchNewTrackerSections() -> [NewTrackerSection] {
        return [
            titleSection,
            detailsSection,
            emojiSection,
            colorSection
        ]
    }
    
    // MARK: - Private Sections

    private var titleSection: NewTrackerSection {
        TextFieldSection(sectionType: .titleTextField)
    }
    
    private var detailsSection: NewTrackerSection {
        DetailsSection(sectionType: .details, models: [
            .category(subtitle: nil),
            .schedule(subtitle: nil)
        ])
    }

    private var emojiSection: NewTrackerSection {
        let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
        let models = emojis.map { EmojiSection.Emoji(emoji: $0) }
        return EmojiSection(sectionType: .emoji, sectionTitle: NSLocalizedString("emoji", comment: "emoji title text"),
                            models: models)
    }
    
    private var colorSection: NewTrackerSection {
        let colors: [UIColor] = [
            .section1, .section2, .section3, .section4, .section5, .section6,
            .section7, .section8, .section9, .section10, .section11, .section12,
            .section13, .section14, .section15, .section16, .section17, .section18
        ]
        let models = colors.map { ColorsSection.CustomColor(color: $0) }
        return ColorsSection(sectionType: .customColor, sectionTitle: NSLocalizedString("color", comment: "color title text"),
                             models: models)
    }
}
