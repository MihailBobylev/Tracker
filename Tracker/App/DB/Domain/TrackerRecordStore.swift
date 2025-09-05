//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Михаил Бобылев on 10.08.2025.
//

import UIKit
import CoreData

final class TrackerRecordStore: NSObject {
    private let calendar = Calendar.current
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    convenience override init() {
        let context = CoreDataManager.shared.context
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        setupFetchedResultsController()
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.completionDate, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        self.fetchedResultsController = controller
        do {
            try controller.performFetch()
        } catch {
            print("❌ Ошибка fetch TrackerRecord: \(error)")
        }
    }
    
    func toggleRecord(for tracker: Tracker, on date: Date) throws {
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return }
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "tracker.id == %@ AND completionDate >= %@ AND completionDate < %@",
            tracker.id as CVarArg,
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        fetchRequest.fetchLimit = 1
        
        if let existingRecord = try context.fetch(fetchRequest).first {
            context.delete(existingRecord)
        } else {
            let record = TrackerRecordCoreData(context: context)
            record.completionDate = date
            record.id = tracker.id
            
            let trackerFetch = TrackerCoreData.fetchRequest()
            trackerFetch.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)
            trackerFetch.fetchLimit = 1
            
            if let trackerCoreData = try context.fetch(trackerFetch).first {
                record.tracker = trackerCoreData
            } else {
                print("toggleRecord: Не найден TrackerCoreData для id \(tracker.id)")
            }
        }
        
        do {
            try context.save()
        } catch {
            print("toggleRecord: Ошибка при сохранении: \(error)")
        }
    }
    
    func isTrackerCompleted(_ tracker: Tracker, on date: Date) -> Bool {
        let startOfDay = calendar.startOfDay(for: date)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else { return false }
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "id == %@ AND completionDate >= %@ AND completionDate < %@",
            tracker.id as CVarArg,
            startOfDay as NSDate,
            endOfDay as NSDate
        )
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.count(for: fetchRequest) > 0
        } catch {
            print("Ошибка при проверке выполнения трекера: \(error)")
            return false
        }
    }

    func completionCount(for tracker: Tracker) -> Int {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)

        do {
            return try context.count(for: fetchRequest)
        } catch {
            print("Ошибка fetch TrackerRecord: \(error)")
            return 0
        }
    }
    
    func completedTrackersCount() -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            print("Ошибка при получении количества: \(error)")
            return 0
        }
    }
}
