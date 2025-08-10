//
//  NewTrackerManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

final class NewTrackerService {
    func fetchNewTrackerSections() -> [NewTrackerSection] {
        return [
            TextFieldSection(sectionType: .titleTextField),
            DetailsSection(sectionType: .details, models: [
                .category(subtitle: nil),
                .schedule(subtitle: nil)
            ]),
            EmojiSection(sectionType: .emoji, sectionTitle: "Emoji", models: [
                .init(emoji: "🙂"), .init(emoji: "😻"), .init(emoji: "🌺"), .init(emoji: "🐶"),
                .init(emoji: "❤️"), .init(emoji: "😱"), .init(emoji: "😇"), .init(emoji: "😡"),
                .init(emoji: "🥶"), .init(emoji: "🤔"), .init(emoji: "🙌"), .init(emoji: "🍔"),
                .init(emoji: "🥦"), .init(emoji: "🏓"), .init(emoji: "🥇"), .init(emoji: "🎸"),
                .init(emoji: "🏝"), .init(emoji: "😪")
            ]),
            ColorsSection(sectionType: .customColor, sectionTitle: "Цвет", models: [
                .init(color: .section1), .init(color: .section2), .init(color: .section3), .init(color: .section4),
                .init(color: .section5), .init(color: .section6), .init(color: .section7), .init(color: .section8),
                .init(color: .section9), .init(color: .section10), .init(color: .section11), .init(color: .section12),
                .init(color: .section13), .init(color: .section14), .init(color: .section15), .init(color: .section16),
                .init(color: .section17), .init(color: .section18)
            ])
        ]
    }
}
