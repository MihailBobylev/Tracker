//
//  CategoriesCollectionViewManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 23.08.2025.
//

import UIKit

protocol CategoriesCollectionViewDelegate: AnyObject {
    func updateSelectedCategory(_ category: TrackerCategory?)
}

protocol CategoriesCollectionViewManagerProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    var delegate: CategoriesCollectionViewDelegate? { get set }
    func setupCollectionView()
    func createLayout() -> UICollectionViewCompositionalLayout
    func updateCollectionView(didUpdate update: TrackerStoreUpdate?)
    func configure(selectedCategory: TrackerCategory?)
}

final class CategoriesCollectionViewManager: NSObject, CategoriesCollectionViewManagerProtocol {
    private let categoriesDataProvider: CategoriesDataProvider
    private let collectionView: UICollectionView
    private var selectedCategory: TrackerCategory?
    private var selectedCategoryIndexPath: IndexPath?
    
    weak var delegate: CategoriesCollectionViewDelegate?
    
    init(collectionView: UICollectionView, categoriesDataProvider: CategoriesDataProvider) {
        self.collectionView = collectionView
        self.categoriesDataProvider = categoriesDataProvider
        super.init()
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
                updateSeparators(for: Array(deleted))
            }
            
            if !inserted.isEmpty {
                collectionView.insertItems(at: Array(inserted))
                updateSeparators(for: Array(inserted))
            }
            
            if !updated.isEmpty {
                collectionView.reloadItems(at: Array(updated))
            }
            
            if !moved.isEmpty {
                for move in moved {
                    collectionView.moveItem(at: move.oldIndexPath, to: move.newIndexPath)
                    updateSeparators(for: [move.oldIndexPath, move.newIndexPath])
                }
            }
        }
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
    
    func configure(selectedCategory: TrackerCategory?) {
        self.selectedCategory = selectedCategory
    }
}

extension CategoriesCollectionViewManager {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        categoriesDataProvider.categoriesStore.fetchedResultsController?.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoriesDataProvider.categoriesStore.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DetailsCell.reuseID,
            for: indexPath
        ) as? DetailsCell else {
            return UICollectionViewCell()
        }
        
        if let categoryCoreData = categoriesDataProvider.categoriesStore.fetchedResultsController?.object(at: indexPath),
           let category = categoriesDataProvider.category(from: categoryCoreData) {
            cell.configure(title: category.title, accessory: .checkmark(isSelected: category.title == selectedCategory?.title))
            if category.title == selectedCategory?.title {
                selectedCategoryIndexPath = indexPath
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? DetailsCell else { return }
        let itemsCount = collectionView.numberOfItems(inSection: indexPath.section)
        let isLastRow = indexPath.row == itemsCount - 1
        cell.setSeparatorHidden(isLastRow)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateSelected(oldIndexPath: selectedCategoryIndexPath, newIndexPath: indexPath)
        selectedCategoryIndexPath = indexPath
        if let categoryCoreData = categoriesDataProvider.categoriesStore.fetchedResultsController?.object(at: indexPath),
           let category = categoriesDataProvider.category(from: categoryCoreData) {
            selectedCategory = category
            delegate?.updateSelectedCategory(selectedCategory)
        }
    }
}

private extension CategoriesCollectionViewManager {
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
