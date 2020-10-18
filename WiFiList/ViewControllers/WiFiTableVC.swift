//
//  WiFiTableVC.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import UIKit
import CoreData

class WiFiTableVC: UIViewController {
    
    // MARK: - Properties & Outlets
    private let wifiTableView = UITableView(frame: .zero, style: .plain)

    private let addButton = UIButton(type: .system)

    private let trashButton = UIButton(type: .system)
    
    lazy var fetchResultsController: NSFetchedResultsController<Wifi> = {
        let fethRequest: NSFetchRequest<Wifi> = Wifi.fetchRequest()
        let favoriteDescriptor = NSSortDescriptor(keyPath: \Wifi.isFavorite, ascending: false)
        let nameDescriptor = NSSortDescriptor(keyPath: \Wifi.networkName, ascending: true)
        fethRequest.sortDescriptors = [favoriteDescriptor, nameDescriptor]
        let context = CoreDataStack.shared.mainContext
        let fetchResultResultsController = NSFetchedResultsController(fetchRequest: fethRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        //fetchResultResultsController.delegate =
        
        return fetchResultResultsController
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
    
    }
    
    func configureNavigationController() {
        guard let navigationController = navigationController else {return}
        navigationController.navigationBar.prefersLargeTitles = true
        //navigationController.navigationBar.largeTitleTextAttributes
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont.roundedFont(ofSize: 35, weight: .bold)]
    }

}

extension WiFiTableVC: NSFetchedResultsControllerDelegate {
    
}
