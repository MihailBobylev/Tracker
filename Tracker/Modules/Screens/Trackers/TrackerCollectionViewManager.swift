//
//  TrackerCollectonViewManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 30.07.2025.
//

import UIKit

protocol TrackerCollectionViewManagerProtocolDelegate: AnyObject {
    func completeTracker(tracker: Tracker, indexPath: IndexPath)
}

protocol TrackerCollectionViewManagerProtocol: UICollectionViewDelegate, UICollectionViewDataSource  {
    var delegate: TrackerCollectionViewManagerProtocolDelegate? { get set }
    func createLayout() -> UICollectionViewCompositionalLayout
    func updateCollectionView(didUpdate update: TrackerStoreUpdate?)
    func setupCollectionView()
    func updateDate(newDate: Date)
}

final class TrackerCollectionViewManager: NSObject, TrackerCollectionViewManagerProtocol {
    private let trackersDataProvider: TrackersDataProvider
    private let collectionView: UICollectionView
    private var selectedDate: Date
    
    weak var delegate: TrackerCollectionViewManagerProtocolDelegate?
    
    init(selectedDate: Date, trackersDataProvider: TrackersDataProvider, collectionView: UICollectionView) {
        self.selectedDate = selectedDate
        self.trackersDataProvider = trackersDataProvider
        self.collectionView = collectionView
        super.init()
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            let headerItem = makeHeader()
            let section = makeCategorySection()
            section.boundarySupplementaryItems = [headerItem]
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16.dvs
        layout.configuration = config
        
        return layout
    }
    
    func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func updateCollectionView(didUpdate update: TrackerStoreUpdate?) {
        guard let update else {
            collectionView.reloadData()
            return
        }
        let insertedSections = update.insertedSections
        let deletedSections = update.deletedSections
        let deleted = update.deletedIndexPaths
        let inserted = update.insertedIndexPaths
        let updated = update.updatedIndexPaths
        let moved = update.movedIndexPaths
        
        collectionView.performBatchUpdates {
            if !deletedSections.isEmpty {
                collectionView.deleteSections(deletedSections)
            }
            
            if !insertedSections.isEmpty {
                collectionView.insertSections(insertedSections)
            }
            
            if !deleted.isEmpty {
                collectionView.deleteItems(at: Array(deleted))
            }
            if !inserted.isEmpty {
                collectionView.insertItems(at: Array(inserted))
            }
            if !updated.isEmpty {
                collectionView.reloadItems(at: Array(updated))
            }
            if !moved.isEmpty {
                for move in moved {
                    collectionView.moveItem(at: move.oldIndexPath, to: move.newIndexPath)
                }
            }
        }
    }
    
    func updateDate(newDate: Date) {
        selectedDate = newDate
    }
}

extension TrackerCollectionViewManager {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerHeaderCell.reuseID,
                for: indexPath
            ) as? TrackerHeaderCell else { return UICollectionReusableView() }
            
            let titleSection = trackersDataProvider.trackerStore.fetchedResultsController?.sections?[indexPath.section].name ?? ""
            header.configure(title: titleSection)
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackersDataProvider.trackerStore.fetchedResultsController?.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trackersDataProvider.trackerStore.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseID,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        
        if let trackerCoreData = trackersDataProvider.trackerStore.fetchedResultsController?.object(at: indexPath),
           let tracker = trackersDataProvider.tracker(from: trackerCoreData) {
            let completedDays = trackersDataProvider.completedDays(for: tracker)
            let isCompleted = trackersDataProvider.isCompleted(tracker, on: selectedDate)
            cell.configure(with: tracker, days: completedDays, isCompleted: isCompleted)
            cell.completeTracker = { [weak self] in
                guard let self else { return }
                delegate?.completeTracker(tracker: tracker, indexPath: indexPath)
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

private extension TrackerCollectionViewManager {
    func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(34.dvs)
        )
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        return headerItem
    }
    
    func makeCategorySection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(148.dvs)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(148.dvs)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(9.dhs)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16.dhs, bottom: 0, trailing: 16.dhs)
        section.interGroupSpacing = 16.dhs
        return section
    }
}
