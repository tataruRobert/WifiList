//
//  WifiController.swift
//  WiFiList
//
//  Created by Tataru Robert on 19/10/2020.
//

import Foundation
import CoreData

class WifiController {
    static let shared = WifiController()

    func addWifi(networkName: String, password: String, iconName: String, isFavorite: Bool = false) {
        Wifi(networkName: networkName, password: password, iconName: iconName, isFavorite: isFavorite, context: .mainContext)
        
        saveToPersistentStore()
    }

    func updateWifi(wifi: Wifi, networkName: String, password: String, iconName: String, isFavorite: Bool) {
        wifi.networkName = networkName
        wifi.password = password
        wifi.iconName = iconName
        wifi.isFavorite = isFavorite
        saveToPersistentStore()
    }

    func updateFavorite(wifi: Wifi, isFavorite: Bool) {
        wifi.isFavorite = isFavorite
        saveToPersistentStore()
    }

    func delete(wifi: Wifi) {
        let context = NSManagedObjectContext.mainContext
        context.delete(wifi)
        saveToPersistentStore()
    }

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

