//
//  CALayer+Ext.swift
//  WiFiList
//
//  Created by Tataru Robert on 18/10/2020.
//

import Foundation
import UIKit

extension CALayer {
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: bounds))
            maskLayer.fillRule = .evenOdd
        }

        maskLayer.path = path.cgPath

        mask = maskLayer
    }
}
