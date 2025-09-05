//
//  StatisticsViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 05.09.2025.
//

import Foundation

protocol StatisticsViewModelProtocol {
    var updateCompletedTrackersCount: ((Int) -> Void)? { get set }
    func viewDidLoad()
}

final class StatisticsViewModel: StatisticsViewModelProtocol {
    private let trackersDataProvider: TrackersDataProvider
    
    init(trackersDataProvider: TrackersDataProvider) {
        self.trackersDataProvider = trackersDataProvider
    }
    
    var updateCompletedTrackersCount: ((Int) -> Void)?
    
    func viewDidLoad() {
        NotificationCenter.default
            .addObserver(
                forName: .trackerComplete,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                updateCompletedTrackersCount?(completedTrackersCount())
            }
        
        updateCompletedTrackersCount?(completedTrackersCount())
    }
}

private extension StatisticsViewModel {
    func completedTrackersCount() -> Int {
        trackersDataProvider.completedTrackersCount()
    }
}
