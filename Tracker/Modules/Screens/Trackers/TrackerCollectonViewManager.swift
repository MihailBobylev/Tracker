//
//  TrackerCollectonViewManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 30.07.2025.
//

import UIKit

protocol TrackerCollectonViewManagerProtocol: UICollectionViewDelegate, UICollectionViewDataSource  {
    func createLayout() -> UICollectionViewCompositionalLayout
    func configure(trackersDataProvider: TrackersDataProvider)
    func updateCollectionView()
}

final class TrackerCollectonViewManager: NSObject, TrackerCollectonViewManagerProtocol {
    private var trackersDataProvider: TrackersDataProvider
    private var collectionView: UICollectionView
    
    init(trackersDataProvider: TrackersDataProvider, collectionView: UICollectionView) {
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
        config.interSectionSpacing = 16
        layout.configuration = config
        
        return layout
    }
    
    func configure(trackersDataProvider: TrackersDataProvider) {
        self.trackersDataProvider = trackersDataProvider
    }
    
    func updateCollectionView() {
        guard let addedIndexPath = trackersDataProvider.addedIndexPath else { return }
        collectionView.performBatchUpdates {
            if collectionView.numberOfSections == addedIndexPath.section {
                collectionView.insertSections([addedIndexPath.section])
            }
            collectionView.insertItems(at: [addedIndexPath])
            
        }
    }
}

extension TrackerCollectonViewManager {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerHeaderCell.reuseID,
                for: indexPath
            ) as? TrackerHeaderCell else { return UICollectionReusableView() }
            
            let titleSection = trackersDataProvider.categories[safe: indexPath.section]?.title ?? ""
            header.configure(title: titleSection)
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackersDataProvider.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackersDataProvider.categories[safe: section]?.trackers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tracker = trackersDataProvider.categories[indexPath.section].trackers[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseID,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let completedDays = trackersDataProvider.completedDays(for: tracker)
        let isCompleted = trackersDataProvider.isCompleted(tracker, on: Date())
        cell.configure(with: tracker, days: completedDays, isCompleted: isCompleted)
        cell.completeTracker = { [weak self] in
            self?.trackersDataProvider.completeTracker(tracker: tracker, for: Date())
        }
        
        return cell
    }
}

private extension TrackerCollectonViewManager {
    func makeHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(34)
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
                heightDimension: .absolute(148)
            )
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(148)
            ),
            subitems: [item]
        )
        group.interItemSpacing = .fixed(9)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }
}
