//
//  DetailsCategoryCellViewModel.swift
//  budget
//
//  Created by Bradley Yin on 10/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift
import UIKit.UIImage

final class DetailsCategoryCellViewModel {
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

    var totalExpenseText: String {
        let totalExpense = category.expenses.map({$0.amount}).reduce(0, +)
        return String(format: "%.2f", totalExpense)
    }

    var totalMoneyText: String {
        return "Budget: " + String(format: "%.2f", category.totalAmount)
    }

    var numberOfTransactionText: String {
        let count = category.expenses.count
        if count > 1 {
            return "\(count) transactions"
        } else {
            return "\(count) transaction"
        }
    }

    var percentText: String {
        let totalExpense = category.expenses.map({$0.amount}).reduce(0, +)
        let percent = (totalExpense / category.totalAmount * 100).rounded()
        return "\(percent)%"
    }

    var percent: Double {
        let totalExpense = category.expenses.map({$0.amount}).reduce(0, +)
        let percent = (totalExpense / category.totalAmount * 100).rounded()
        return percent
    }

    init(category: Category) {
        self.category = category
    }
}
