//
//  CategoryIconCellViewModel.swift
//  budget
//
//  Created by Bradley Yin on 10/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift
import UIKit.UIImage

final class CategoryIconCellViewModel {
    private var index: Int

    var icon: UIImage? {
        let imageName = "category\(index)"
        if isSelected {
            return UIImage(named: imageName)?.withTintColor(.white)
        } else {
            return UIImage(named: imageName)?.withTintColor(.black)
        }
    }

    var backgroundColor: UIColor {
        if isSelected {
            return .black
        } else {
            return .white
        }
    }

    var isSelected: Bool

    init(index: Int, isSelected: Bool) {
        self.index = index
        self.isSelected = isSelected
    }
}
