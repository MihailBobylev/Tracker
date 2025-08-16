//
//  TrackerStoreUpdate.swift
//  Tracker
//
//  Created by Михаил Бобылев on 16.08.2025.
//

import Foundation

struct TrackerStoreUpdate {
    struct Move: Hashable {
        let oldIndexPath: IndexPath
        let newIndexPath: IndexPath
    }
    
    let insertedSections: IndexSet
    let deletedSections: IndexSet
    
    let insertedIndexPaths: Set<IndexPath>
    let deletedIndexPaths: Set<IndexPath>
    let updatedIndexPaths: Set<IndexPath>
    let movedIndexPaths: Set<Move>
}
