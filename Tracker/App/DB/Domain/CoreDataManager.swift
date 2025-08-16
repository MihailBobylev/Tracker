//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Михаил Бобылев on 15.08.2025.
//

import CoreData

final class CoreDataManager {
    private struct Constants {
        static let dbName = "TrackersDB"
    }
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: Constants.dbName)
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Ошибка загрузки Core Data: \(error)")
            }
        }
    }
}
