//
//  CoreDataStack.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    /// Access to the Persistent Container
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WiFiList")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        })
        // May need to be disabled if dataset is too large for performance reasons
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension NSManagedObjectContext {
    static let mainContext = CoreDataStack.shared.mainContext
}
