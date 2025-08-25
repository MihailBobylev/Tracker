//
//  CategoriesDataProvider.swift
//  Tracker
//
//  Created by Михаил Бобылев on 24.08.2025.
//

import Foundation

protocol CategoriesDataProviderDelegate: AnyObject {
    func updateCollection(didUpdate update: TrackerStoreUpdate?)
}

final class CategoriesDataProvider {
    lazy var categoriesStore: TrackerCategoryStore = {
        let store = TrackerCategoryStore()
        store.delegate = self
        return store
    }()
    
    weak var delegate: CategoriesDataProviderDelegate?
    
    func category(from coreData: TrackerCategoryCoreData) -> TrackerCategory? {
        categoriesStore.category(from: coreData)
    }
    
    func addNewCategory(_ category: TrackerCategory) {
        try? categoriesStore.addCategory(category: category)
    }
}

extension CategoriesDataProvider: TrackerStoreDelegate {
    func store(didUpdate update: TrackerStoreUpdate?) {
        delegate?.updateCollection(didUpdate: update)
    }
}
