//
//  UITextField+Utilities.swift
//  budget
//
//  Created by Bradley Yin on 9/26/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    //To add bottom border only
    func setBottomBorder(withColor color: UIColor = .black) {
        self.borderStyle = UITextField.BorderStyle.none
        self.backgroundColor = UIColor.clear
        let width: CGFloat = 1.0

        let borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(borderLine)
        borderLine.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        borderLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        borderLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        borderLine.heightAnchor.constraint(equalToConstant: width).isActive = true
        borderLine.backgroundColor = color
    }
}
