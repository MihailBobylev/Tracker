//
//  TrackerStore.swift
//  Tracker
//
//  Created by Михаил Бобылев on 10.08.2025.
//

import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func store(
        didUpdate update: TrackerStoreUpdate?
    )
}

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
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
    }
    
    func reconfigureFetchedResultsController(for weekday: WeekdayType, searchText: String?) {
        var predicates: [NSPredicate] = [
            NSPredicate(format: "%K CONTAINS %@", #keyPath(TrackerCoreData.schedule), weekday.mask)
        ]
        
        if let text = searchText, !text.isEmpty {
            let titlePredicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(TrackerCoreData.title), text)
            predicates.append(titlePredicate)
        }
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        if let frc = fetchedResultsController {
            frc.fetchRequest.predicate = compoundPredicate
            
            do {
                try frc.performFetch()
                delegate?.store(didUpdate: nil)
            } catch {
                print("❌ Fetch error: \(error)")
            }
        } else {
            let request = TrackerCoreData.fetchRequest()
            request.predicate = compoundPredicate
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: true),
                NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)
            ]
            
            let controller = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: #keyPath(TrackerCoreData.category.title),
                cacheName: nil
            )
                
            controller.delegate = self
            self.fetchedResultsController = controller
            
            do {
                try controller.performFetch()
            } catch {
                print("❌ Fetch error: \(error)")
            }
        }
    }
    
    func addTracker(_ tracker: Tracker, to categoryTitle: String) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.title = tracker.title
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = tracker.color.hexString
        trackerCoreData.schedule = tracker.schedule.map { $0.mask }.joined()

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), categoryTitle)
        fetchRequest.fetchLimit = 1

        guard let category = try context.fetch(fetchRequest).first else {
            throw NSError(domain: "AddTracker", code: 1, userInfo: [NSLocalizedDescriptionKey: "Category \(categoryTitle) not found"])
        }

        trackerCoreData.category = category

        do {
            try context.save()
        } catch {
            print("Ошибка при сохранении: \(error)")
        }
    }
    
    func tracker(from coreData: TrackerCoreData) -> Tracker? {
        guard let id = coreData.id,
              let title = coreData.title,
              let emoji = coreData.emoji,
              let colorHex = coreData.color else { return nil }

        let color = UIColor(hex: colorHex)
        
        var schedule: Set<WeekdayType> = []
        if let scheduleString = coreData.schedule {
            schedule = Set(
                scheduleString.compactMap { char in
                    guard let dayInt = Int(String(char)) else { return nil }
                    return WeekdayType(rawValue: dayInt)
                }
            )
        }

        return Tracker(id: id, title: title, color: color, emoji: emoji, schedule: schedule)
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
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
