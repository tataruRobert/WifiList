//
//  AddWifiVC.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import UIKit

class AddWifiVC: UIViewController {
    
    enum IconInfo: String {
        case home = "Home"
        case homeIconName = "house.fill"
        case work = "Work"
        case workIconName = "briefcase.fill"
        

        var homeImage: UIImage {
            return UIImage(systemName: "house.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))!
        }

        var workImage: UIImage {
            return UIImage(systemName: "briefcase.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))!
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .mySecondaryBackground
        
    }
    

   

}
