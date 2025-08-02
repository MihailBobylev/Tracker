//
//  TrackerCollectonViewManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 30.07.2025.
//

import UIKit

protocol TrackerCollectonViewManagerProtocolDelegate: AnyObject {
    func completeTracker(tracker: Tracker, indexPath: IndexPath)
}

protocol TrackerCollectonViewManagerProtocol: UICollectionViewDelegate, UICollectionViewDataSource  {
    var delegate: TrackerCollectonViewManagerProtocolDelegate? { get set }
    func createLayout() -> UICollectionViewCompositionalLayout
    func updateCollectionView()
    func setupCollectionView()
    func completeTracker(tracker: Tracker, for date: Date, indexPath: IndexPath)
    func updateDate(newDate: Date)
}

final class TrackerCollectonViewManager: NSObject, TrackerCollectonViewManagerProtocol {
    private let trackersDataProvider: TrackersDataProvider
    private let collectionView: UICollectionView
    private var selectedDate: Date?
    
    weak var delegate: TrackerCollectonViewManagerProtocolDelegate?
    
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
        config.interSectionSpacing = 16.dvs
        layout.configuration = config
        
        return layout
    }
    
    func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func updateCollectionView() {
        collectionView.reloadData()
    }
    
    func completeTracker(tracker: Tracker, for date: Date, indexPath: IndexPath) {
        trackersDataProvider.completeTracker(tracker: tracker, for: date) { 
            collectionView.performBatchUpdates {
                collectionView.reloadItems(at: [indexPath])
            }
        }
    }
    
    func updateDate(newDate: Date) {
        selectedDate = newDate
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
            
            let titleSection = trackersDataProvider.visibleCategories[safe: indexPath.section]?.title ?? ""
            header.configure(title: titleSection)
            return header
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        trackersDataProvider.visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackersDataProvider.visibleCategories[safe: section]?.trackers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tracker = trackersDataProvider.visibleCategories[indexPath.section].trackers[indexPath.item]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrackerCell.reuseID,
            for: indexPath
        ) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let completedDays = trackersDataProvider.completedDays(for: tracker)
        let isCompleted = trackersDataProvider.isCompleted(tracker, on: selectedDate)
        cell.configure(with: tracker, days: completedDays, isCompleted: isCompleted)
        cell.completeTracker = { [weak self] in
            guard let self else { return }
            delegate?.completeTracker(tracker: tracker, indexPath: indexPath)
        }
        
        return cell
    }
}

private extension TrackerCollectonViewManager {
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
