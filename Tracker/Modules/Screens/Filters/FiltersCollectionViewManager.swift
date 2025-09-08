//
//  FiltersCollectionViewManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 08.09.2025.
//

import UIKit

protocol FiltersCollectionViewDelegate: AnyObject {
    func updateSelectedFilter(_ filter: FilterMode)
}

protocol FiltersCollectionViewManagerProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: FiltersCollectionViewDelegate? { get set }
    func setupCollectionView()
    func createLayout() -> UICollectionViewCompositionalLayout
}

final class FiltersCollectionViewManager: NSObject, FiltersCollectionViewManagerProtocol {
    private let collectionView: UICollectionView
    private let filterItems = FilterMode.allCases
    private var selectedFilterIndexPath: IndexPath?
    private var selectedFilter: FilterMode {
        didSet {
            delegate?.updateSelectedFilter(selectedFilter)
        }
    }
    
    weak var delegate: FiltersCollectionViewDelegate?
    
    init(collectionView: UICollectionView, selectedFilter: FilterMode) {
        self.collectionView = collectionView
        self.selectedFilter = selectedFilter
        super.init()
    }
    
    func setupCollectionView() {
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self else { return nil }
            let section = makeDayOfWeekSection()
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        layout.configuration = config
        layout.register(DetailsBackgroundDecorationView.self, forDecorationViewOfKind: DetailsBackgroundDecorationView.identifier)
        
        return layout
    }
}

extension FiltersCollectionViewManager {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailsCell.reuseID,
            for: indexPath
        ) as? DetailsCell else {
            return UICollectionViewCell()
        }
        let item = filterItems[indexPath.item]
        let isSelected = item.rawValue == selectedFilter.rawValue
        if isSelected {
            selectedFilterIndexPath = indexPath
        }
        cell.configure(title: item.title, accessory: .checkmark(isSelected: isSelected))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailsCell else { return }
        let itemsCount = collectionView.numberOfItems(inSection: indexPath.section)
        let isLastRow = indexPath.row == itemsCount - 1
        cell.setSeparatorHidden(isLastRow)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelected(oldIndexPath: selectedFilterIndexPath, newIndexPath: indexPath)
        selectedFilterIndexPath = indexPath
        selectedFilter = filterItems[indexPath.item]
    }
}

private extension FiltersCollectionViewManager {
    func makeDayOfWeekSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(75.dvs)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(75.dvs)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16.dhs, bottom: 0, trailing: 16.dhs)
        
        let backgroundItem = NSCollectionLayoutDecorationItem.background(elementKind: DetailsBackgroundDecorationView.identifier)
        backgroundItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16.dhs, bottom: 0, trailing: 16.dhs)
        section.decorationItems = [backgroundItem]
        
        return section
    }
    
    func updateSelected(oldIndexPath: IndexPath?, newIndexPath: IndexPath?) {
        
        func setupBorder(for indexPath: IndexPath?, isSelected: Bool) {
            guard let indexPath,
                  let cell = collectionView.cellForItem(at: indexPath) as? DetailsCell else { return
            }
            cell.changeSelectedState(to: isSelected)
        }
        
        guard oldIndexPath != newIndexPath else { return }
        
        setupBorder(for: oldIndexPath, isSelected: false)
        setupBorder(for: newIndexPath, isSelected: true)
    }
    
    func updateSeparators(for indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item > 0 {
                let prevIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
                collectionView.reloadItems(at: [prevIndexPath])
            }
        }
    }
}
