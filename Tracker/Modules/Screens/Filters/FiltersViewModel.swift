//
//  FiltersViewModel.swift
//  Tracker
//
//  Created by Михаил Бобылев on 08.09.2025.
//

import UIKit

protocol FiltersViewModelDelegate: AnyObject {
    func closeController()
}

protocol FiltersViewModelProtocol {
    var delegate: FiltersViewModelDelegate? { get set }
    func viewDidLoad(collectionView: UICollectionView)
}

final class FiltersViewModel: FiltersViewModelProtocol {
    private let trackersDataProvider: TrackersDataProvider
    private var selectedFilter: FilterMode
    private var filtersCollectionViewManager: FiltersCollectionViewManagerProtocol?
    
    weak var delegate: FiltersViewModelDelegate?
    
    var filterSelected: ((FilterMode) -> Void)?
    
    init(selectedFilter: FilterMode, trackersDataProvider: TrackersDataProvider) {
        self.selectedFilter = selectedFilter
        self.trackersDataProvider = trackersDataProvider
    }
    
    func viewDidLoad(collectionView: UICollectionView) {
        configureCategoriesCollectionViewManager(with: collectionView)
    }
    
    func configureCategoriesCollectionViewManager(with collectionView: UICollectionView) {
        filtersCollectionViewManager = FiltersCollectionViewManager(collectionView: collectionView, selectedFilter: selectedFilter)
        filtersCollectionViewManager?.setupCollectionView()
        filtersCollectionViewManager?.delegate = self
    }
}

extension FiltersViewModel: FiltersCollectionViewDelegate {
    func updateSelectedFilter(_ filter: FilterMode) {
        selectedFilter = filter
        filterSelected?(filter)
        delegate?.closeController()
    }
}
