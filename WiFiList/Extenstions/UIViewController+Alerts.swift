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

}
