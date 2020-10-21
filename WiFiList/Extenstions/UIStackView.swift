//
//  UIStackView.swift
//  WiFiList
//
//  Created by Tataru Robert on 21/10/2020.
//

import Foundation
import UIKit

extension UIStackView {

    /// Creates and returns a stack view. Default axis is vertical.
    static func fillStackView(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat, with views: [UIView]) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = .fill
        stackView.distribution = .fill
        views.forEach { stackView.addArrangedSubview($0) }
        return stackView
    }
}
