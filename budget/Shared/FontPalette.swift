//
//  FontPalette.swift
//  budget
//
//  Created by Bradley Yin on 6/13/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

public struct FontPalette {
    public enum FontType: String {
        case light = "SFCompactText-Light"
        case medium = "SFCompactText-Medium"
        //case regular = "Montserrat-Regular"
        case semiBold = "SFCompactText-Semibold"
    }

    public static func attrString(text: String?, characterSpacing: CGFloat, lineHeight: CGFloat, fontSize: CGFloat, fontType: FontType, textColor: UIColor) -> NSAttributedString {
        guard let text = text else { return NSAttributedString(string: "") }
        let attrString = NSMutableAttributedString(string: text)
        let font = UIFont(name: fontType.rawValue, size: fontSize)!
        attrString.addAttributes([NSAttributedString.Key.kern: characterSpacing,
                                  NSAttributedString.Key.font: font,
                                  NSAttributedString.Key.foregroundColor: textColor], range: NSRange(location: 0, length: text.count))

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight / font.pointSize
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, text.count))
        return attrString
    }
    
    public static func font(size: CGFloat, fontType: FontType) -> UIFont {
        return UIFont(name: fontType.rawValue, size: size)!
    }

//    static func fontSize(_ size: FontSize) -> CGFloat {
//        if UIApplication. {
//            return max(size.rawValue - 2.0, FontSize.minimum.rawValue)
//        } else {
//            return size.rawValue
//        }
//    }
}

