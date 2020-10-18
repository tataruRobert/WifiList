//
//  WifiModel.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import Foundation
import CoreData

class WifiModel{
    static let shared = WifiModel()
    
    func loadFromPersistentStore() -> [Wifi] {
        let fetchRequest: NSFetchRequest<Wifi> = Wifi.fetchRequest()
        let context = NSManagedObjectContext.mainContext

        do {
            let wifiList = try context.fetch(fetchRequest)
            return wifiList
        } catch {
            NSLog("Error fetching wifi list: \(error)")
            return []
        }
    }

    func saveToPersistentStore() {
        let context = NSManagedObjectContext.mainContext

        do {
            try context.save()
        } catch {
            NSLog("Error saving main context: \(error)")
            context.reset()
        }
    }
}
