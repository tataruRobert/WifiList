//
//  WifiCell.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import Foundation
import UIKit

class WifiCell: UITableViewCell {
    
    var wifi: Wifi?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .myBackground
        accessoryType = .disclosureIndicator
    }

}
