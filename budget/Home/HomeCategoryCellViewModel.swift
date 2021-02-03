//
//  HomeCategoryCellViewModel.swift
//  budget
//
//  Created by Bradley Yin on 9/5/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift
import UIKit.UIImage

final class HomeCategoryCellViewModel {
    private var category: Category

    var title: String {
        return category.name
    }

    var icon: UIImage? {
        if category.iconImageName.isEmpty {
            return UIImage(named: "category_uncategorized")
        } else {
            return UIImage(named: category.iconImageName)
        }
    }

    var remainingMoneyText: String {
        let totalExpense = category.expenses.map({$0.amount}).reduce(0, +)
        let remainAmount = category.totalAmount - totalExpense
        return String(format: "%.2f", remainAmount)
    }

    var totalMoneyText: String {
        return String(format: "%.2f", category.totalAmount)
    }

    var percent: Double {
        let totalExpense = category.expenses.map({$0.amount}).reduce(0, +)
        let remainAmount = category.totalAmount - totalExpense
        return remainAmount / category.totalAmount
    }

    init(category: Category) {
        self.category = category
    }
}
