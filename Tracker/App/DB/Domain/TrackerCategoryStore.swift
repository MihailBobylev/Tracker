//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Михаил Бобылев on 10.08.2025.
//

import UIKit
import CoreData

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    weak var delegate: TrackerStoreDelegate?
    
    private var insertedSections: IndexSet = []
    private var deletedSections: IndexSet = []

    private var insertedIndexPaths: Set<IndexPath> = []
    private var deletedIndexPaths: Set<IndexPath> = []
    private var updatedIndexPaths: Set<IndexPath> = []
    private var movedIndexPaths: Set<TrackerStoreUpdate.Move> = []
    
    convenience override init() {
        let context = CoreDataManager.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    func addCategory(category: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = category.title
        
        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении: \(error)")
        }
    }
    
    func category(from coreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = coreData.title else { return nil }
        return TrackerCategory(title: title, trackers: [])
    }
}

private extension TrackerCategoryStore {
    func setupFetchedResultsController() {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        fetchedResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            print("Ошибка при загрузке категорий: \(error)")
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedSections = []
        deletedSections = []
        insertedIndexPaths = []
        deletedIndexPaths = []
        updatedIndexPaths = []
        movedIndexPaths = Set<TrackerStoreUpdate.Move>()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            didUpdate: TrackerStoreUpdate(
                insertedSections: insertedSections,
                deletedSections: deletedSections,
                insertedIndexPaths: insertedIndexPaths,
                deletedIndexPaths: deletedIndexPaths,
                updatedIndexPaths: updatedIndexPaths,
                movedIndexPaths: movedIndexPaths
            )
        )
        insertedSections = []
        deletedSections = []
        insertedIndexPaths = []
        deletedIndexPaths = []
        updatedIndexPaths = []
        movedIndexPaths = []
    }
    
    func controller(_ controller: NSFetchedResultsController<any NSFetchRequestResult>,
                    didChange sectionInfo: any NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        case .delete:
            deletedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { fatalError() }
            insertedIndexPaths.insert(newIndexPath)

        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexPaths.insert(indexPath)

        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexPaths.insert(indexPath)

        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexPaths.insert(.init(oldIndexPath: oldIndexPath, newIndexPath: newIndexPath))

        @unknown default:
            fatalError()
        }
    }
}
