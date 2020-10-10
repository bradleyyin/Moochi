//
//  CategorySelectionCellViewModel.swift
//  budget
//
//  Created by Bradley Yin on 10/6/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxRealm
import RxSwift
import UIKit.UIImage

final class CategorySelectionCellViewModel {
    private var category: Category?

    var title: String {
        if let category = category {
            return category.name
        } else {
            return "Uncategorized"
        }

    }

    var icon: UIImage? {
        if let category = category {
            return UIImage(named: "category_cart")
        } else {
            return UIImage(named: "category_uncategorized")
        }
    }

    var isSelected: Bool

    init(category: Category?, isSelected: Bool) {
        self.category = category
        self.isSelected = isSelected
    }
}
