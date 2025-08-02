//
//  NewTrackerManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 29.07.2025.
//

import Foundation

final class NewTrackerService {
    func fetchNewTrackerSections() -> [NewTrackerSectionType] {
        return [
            .titleTextField,
            .details([
                .category(subtitle: nil),
                .schedule(subtitle: nil)
            ])
        ]
    }
}
