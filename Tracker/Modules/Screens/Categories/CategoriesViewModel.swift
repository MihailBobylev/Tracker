//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 23.08.2025.
//

import UIKit

protocol CategoriesViewModelDelegate: AnyObject {
    func updateEmptyState(to isShow: Bool)
    func closeController()
}

protocol CategoriesViewModelProtocol {
    var delegate: CategoriesViewModelDelegate? { get set }
    func viewDidLoad(collectionView: UICollectionView)
    func addCategoryButtonTapped()
}

final class CategoriesViewModel: CategoriesViewModelProtocol {
    private let categoriesDataProvider: CategoriesDataProvider
    private var selectedCategory: TrackerCategory?
    private var categoriesCollectionViewManager: CategoriesCollectionViewManagerProtocol?
    
    weak var delegate: CategoriesViewModelDelegate?
    
    var onDaysSelected: ((Set<WeekdayType>) -> Void)?
    var categorySelected: ((TrackerCategory?) -> Void)?
    var didTapAddNewCategory: (() -> Void)?
    
    init(selectedCategory: TrackerCategory?, categoriesDataProvider: CategoriesDataProvider) {
        self.selectedCategory = selectedCategory
        self.categoriesDataProvider = categoriesDataProvider
        self.categoriesDataProvider.delegate = self
    }
    
    func viewDidLoad(collectionView: UICollectionView) {
        configureCategoriesCollectionViewManager(with: collectionView)
        updateEmptyState()
    }
    
    func configureCategoriesCollectionViewManager(with collectionView: UICollectionView) {
        categoriesCollectionViewManager = CategoriesCollectionViewManager(collectionView: collectionView,
                                                                          categoriesDataProvider: categoriesDataProvider)
        categoriesCollectionViewManager?.setupCollectionView()
        categoriesCollectionViewManager?.configure(selectedCategory: selectedCategory)
        categoriesCollectionViewManager?.delegate = self
    }
    
    func addNewCategory(name: String) {
        let newCategory: TrackerCategory = .init(title: name, trackers: [])
        categoriesDataProvider.addNewCategory(newCategory)
    }
    
    func addCategoryButtonTapped() {
        didTapAddNewCategory?()
    }
}

extension CategoriesViewModel: CategoriesDataProviderDelegate {
    func updateCollection(didUpdate update: TrackerStoreUpdate?) {
        categoriesCollectionViewManager?.updateCollectionView(didUpdate: update)
        updateEmptyState()
    }
}

extension CategoriesViewModel: CategoriesCollectionViewDelegate {
    func updateSelectedCategory(_ category: TrackerCategory?) {
        selectedCategory = category
        categorySelected?(category)
        delegate?.closeController()
    }
}

private extension CategoriesViewModel {
    func updateEmptyState() {
        delegate?.updateEmptyState(
            to: categoriesDataProvider.categoriesStore.fetchedResultsController?.sections?[0].numberOfObjects == 0
        )
    }
}
