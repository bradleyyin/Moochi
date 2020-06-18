//
//  UIViewController+extension.swift
//  budget
//
//  Created by Bradley Yin on 6/13/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import UIKit
import SnapKit

extension UIViewController {
    var top: ConstraintItem {
        return view.safeAreaLayoutGuide.snp.top
    }
    
    var bottom: ConstraintItem {
        return view.safeAreaLayoutGuide.snp.bottom
    }
}
