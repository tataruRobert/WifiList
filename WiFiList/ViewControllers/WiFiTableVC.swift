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
    
    lazy var fetchedResultsController: NSFetchedResultsController<Wifi> = {
        let fethRequest: NSFetchRequest<Wifi> = Wifi.fetchRequest()
        let favoriteDescriptor = NSSortDescriptor(keyPath: \Wifi.isFavorite, ascending: false)
        let nameDescriptor = NSSortDescriptor(keyPath: \Wifi.networkName, ascending: true)
        fethRequest.sortDescriptors = [favoriteDescriptor, nameDescriptor]
        
        let context = CoreDataStack.shared.mainContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fethRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error performing initial fetch for frc: \(error)")
        }
        
        return fetchedResultsController
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
        configureTableView()
        configureRoundButton()
    
    }
    
    func configureNavigationController() {
        guard let navigationController = navigationController else {return}
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes = [
            .foregroundColor : UIColor.myGlobalTint,
            .font : UIFont.roundedFont(ofSize: 35, weight: .bold)]
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.myGlobalTint,
                                                                   .font : UIFont.roundedFont(ofSize: 20, weight: .bold)]
        let count = fetchedResultsController.fetchedObjects?.count ?? 0
        navigationItem.rightBarButtonItem = count > 0 ? editButtonItem : nil
    }
    
    func configureTableView() {
        view.addSubview(wifiTableView)
        wifiTableView.translatesAutoresizingMaskIntoConstraints = false
        wifiTableView.register(WifiCell.self, forCellReuseIdentifier: "WifiCell")
        NSLayoutConstraint.activate([
            wifiTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            wifiTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            wifiTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            wifiTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        ])
        wifiTableView.dataSource = self
        wifiTableView.delegate = self
        wifiTableView.separatorStyle = .none
        wifiTableView.backgroundColor = .myBackground
        wifiTableView.tintColor = .myGlobalTint
        wifiTableView.allowsMultipleSelection = false
        wifiTableView.allowsSelectionDuringEditing = true
        wifiTableView.allowsMultipleSelectionDuringEditing = true
    }
    
    func configureRoundButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(roundButtonTapped(_:)), for: .touchUpInside)
        
        addButton.tintColor = .myGlobalTint
        let configuration = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        addButton.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: configuration), for: .normal)
        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalTo: addButton.heightAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
    
    @objc private func roundButtonTapped(_ sender: UIButton) {
        if self.isEditing == false{
            let addWifiVC = AddWifiVC()
            
            let navController = UINavigationController(rootViewController: addWifiVC)
            navController.modalPresentationStyle = .automatic
                

            present(navController, animated: true)
           
        }else {
            
        }
    }

}


extension WiFiTableVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    func tableView(_ tableView: UITableView,
                   shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
        self.setEditing(true, animated: true)
    }

    func tableViewDidEndMultipleSelectionInteraction(_ tableView: UITableView) {
        print("\(#function)")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.myBackground
            return view
        }()

        let cell = tableView.dequeueReusableCell(withIdentifier: "WifiCell", for: indexPath) as? WifiCell
        let wifi = fetchedResultsController.object(at: indexPath)
        cell?.wifi = wifi
        cell?.backgroundColor = .myBackground
        cell?.selectedBackgroundView = backgroundView

        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isEditing {
            let wifi = fetchedResultsController.object(at: indexPath)
            let detailVC = DetailVC(with: wifi)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            //selectedRowsCount = tableView.indexPathsForSelectedRows?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isEditing {
            //selectedRowsCount = tableView.indexPathsForSelectedRows?.count ?? 0
        }
    }
    
}

extension WiFiTableVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        wifiTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let count = fetchedResultsController.fetchedObjects?.count {
            if navigationItem.rightBarButtonItem == nil && count > 0 {
                navigationItem.rightBarButtonItem = editButtonItem
            } else if count == 0 {
                navigationItem.rightBarButtonItem = nil
            }
        }

        wifiTableView.endUpdates()
    }

//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
//                    didChange sectionInfo: NSFetchedResultsSectionInfo,
//                    atSectionIndex sectionIndex: Int,
//                    for type: NSFetchedResultsChangeType) {
//        let indexSet = IndexSet([sectionIndex])
//        switch type {
//        case .insert:
//            wifiTableView.insertSections(indexSet, with: .fade)
//        case .delete:
//            wifiTableView.deleteSections(indexSet, with: .fade)
//        default:
//            print(#line, #file, "unexpected NSFetchedResultsChangeType: \(type)")
//        }
//    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            wifiTableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath,
                let newIndexPath = newIndexPath else { return }
            let cell = wifiTableView.cellForRow(at: indexPath) as? WifiCell
            cell?.updateViews()
            wifiTableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            wifiTableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            wifiTableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            print(#line, #file, "unknown NSFetchedResultsChangeType: \(type)")
        }
    }

}
