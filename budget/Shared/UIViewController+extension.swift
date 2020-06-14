//
//  UIViewController+extension.swift
//  budget
//
//  Created by Bradley Yin on 6/13/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit

extension UIViewController {
    var top: CGFloat {
        return view.safeAreaInsets.top
    }
    
    var bottom: CGFloat {
        return view.safeAreaInsets.bottom
    }
}
