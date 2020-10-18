//
//  UIFont+Rounded.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import Foundation
import UIKit

extension UIFont {
    static func roundedFont(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        // Will be SF Compact or standard SF in case of failure.
        if let descriptor = UIFont.systemFont(ofSize: fontSize, weight: weight).fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: fontSize)
        } else {
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    static func rounded(from oldFont: UIFont) -> UIFont {
        let design = UIFontDescriptor.SystemDesign.rounded
        guard let descriptor = oldFont.fontDescriptor.withDesign(design) else { return oldFont }
        return UIFont(descriptor: descriptor, size: oldFont.pointSize)
    }
}
