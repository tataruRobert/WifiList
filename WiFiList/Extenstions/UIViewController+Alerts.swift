//
//  UIViewController+Alerts.swift
//  WiFiList
//
//  Created by Tataru Robert on 19/10/2020.
//

import Foundation
import UIKit

extension UIViewController {
    // MARK: - Alerts
    /// Use this action sheet when user is editing or creating a new WiFi network
    func presentAttemptToDismissActionSheet(saveHandler: ((UIAlertAction) -> Void)?, discardHandler: ((UIAlertAction) -> Void)?, completionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = .myGlobalTint

        let saveAction = UIAlertAction(title: "Save WiFi", style: .default, handler: saveHandler)
        let discardAction = UIAlertAction(title: "Discard Changes", style: .default, handler: discardHandler)
        let resumeAction = UIAlertAction(title: "Resume Editing", style: .cancel)

        [saveAction, discardAction, resumeAction].forEach(alertController.addAction)
        present(alertController, animated: true)
    }

    /// Use this action sheet if user selects delete when prompted by action sheet from ellipsis on DetailVC -> Used for single deletion
    func presentSecondaryDeleteAlertSingle(wifi: Wifi, deleteHandler: ((UIAlertAction) -> Void)? = nil, completionHandler: (() -> Void)? = nil) {
        let deleteStr = "Are you sure you want to delete \(wifi.networkName ?? "this WiFi")?"
        let alertController = UIAlertController(title: deleteStr, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = .myGlobalTint

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        [deleteAction, cancelAction].forEach(alertController.addAction)
        present(alertController, animated: true, completion: completionHandler)
    }
    
    func presentSecondaryDeleteAlertMultiple(count: Int? = 0, deleteHandler: ((UIAlertAction) -> Void)? = nil, completionHandler: (() -> Void)? = nil) {
        // This should never be prompted if count is 0 as the user will not have the option to multi select
        let multiDeleteStr = "Are you sure you want to delete \(count ?? 0) networks?"
        let singleDeleteStr = "Are you sure you want to delete this network?"
        let deleteStr = count == 1 ? singleDeleteStr : multiDeleteStr

        let alertController = UIAlertController(title: deleteStr, message: "This cannot be undone.", preferredStyle: .actionSheet)
        alertController.view.tintColor = .myGlobalTint

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        [deleteAction, cancelAction].forEach(alertController.addAction)
        present(alertController, animated: true, completion: completionHandler)
    }

}
