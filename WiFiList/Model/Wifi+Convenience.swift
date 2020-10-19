//
//  Wifi+Convenience.swift
//  WiFiList
//
//  Created by Tataru Robert on 19/10/2020.
//

import Foundation
<<<<<<< HEAD
import CoreData

extension Wifi {
    @discardableResult convenience init(networkName: String, password: String, iconName: String, isFavorite: Bool = false, context: NSManagedObjectContext) {
        self.init(context: context)
        self.networkName = networkName
        self.password = password
        self.iconName = iconName
        self.isFavorite = isFavorite
    }

}
=======
>>>>>>> ba62ef6f5990e3aa258d5a948a6b7d3dfc48a1fe
