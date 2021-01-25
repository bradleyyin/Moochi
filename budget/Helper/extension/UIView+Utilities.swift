//
//  UIView+Utilities.swift
//  budget
//
//  Created by Bradley Yin on 10/6/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func applyShadow(_ showShadow: Bool = true) {
        if showShadow {
            self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 6.0
            self.clipsToBounds = false
        } else {
            self.layer.shadowRadius = 0
        }
    }

    func applyShadow(offset: CGFloat, radius: CGFloat, color: CGColor) {
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: offset, height: offset)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = radius
        self.clipsToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
    }

    func removeShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0
        self.layer.shadowRadius = 0
        self.clipsToBounds = false
    }
}
