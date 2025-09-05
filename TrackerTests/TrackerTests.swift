//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Михаил Бобылев on 05.09.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    func testViewController() {
        let viewModel = TrackersViewModelMock()
        let vc = TrackersViewController(viewModel: viewModel)
        
        assertSnapshot(of: vc, as: .image)
    }
}
