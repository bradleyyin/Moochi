//
//  ColorPalette.swift
//  budget
//
//  Created by Bradley Yin on 8/8/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// Initializes UIColor with an integer and alpha value.
    ///
    /// - parameter value: The integer value of the color. E.g. 0xFF0000 is red, 0x0000FF is blue.
    /// - parameter alpha: The alpha value.
    public convenience init(_ value: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat(value >> 16 & 0xFF) / 255.0
        let green = CGFloat(value >> 8 & 0xFF) / 255.0
        let blue = CGFloat(value & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

public struct ColorPalette {
    public static let tabBarGray = UIColor(0xF1F1F1)

    public static let separatorGray = UIColor(0x333333)

    public static let indicatorGray = UIColor(0xC0C0C0)

    public static let red = UIColor(0xFF3B30)

}
