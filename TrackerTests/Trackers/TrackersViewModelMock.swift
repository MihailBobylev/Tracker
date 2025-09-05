//
//  TrackersViewModelMock.swift
//  TrackerTests
//
//  Created by Михаил Бобылев on 05.09.2025.
//

import UIKit
@testable import Tracker

final class TrackersViewModelMock: TrackersViewModelProtocol {
    var selectedDate: Date = Date()
    
    var searchedText: String = ""
    
    var delegate: TrackersViewModelDelegate?
    
    func configureTrackerCollectionViewManager(with collectionView: UICollectionView) {}
    
    func goToAddNewTrackerScreen() {}
    
    func addNewTracker(_ tracker: Tracker, to categoryTitle: String) {}
}
