//
//  WiFiTableVC.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import UIKit

class WiFiTableVC: UIViewController {
    
    // MARK: - Properties & Outlets
    private let wifiTableView = UITableView(frame: .zero, style: .plain)

    private let addButton = UIButton(type: .system)

    private let trashButton = UIButton(type: .system)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationController()
    
    }
    
    func configureNavigationController() {
        guard let navigationController = navigationController else {return}
        navigationController.navigationBar.prefersLargeTitles = true
        //navigationController.navigationBar.largeTitleTextAttributes
        navigationController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font : UIFont]
    }

}
