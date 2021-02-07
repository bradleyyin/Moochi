//
//  GoalCellViewModel.swift
//  budget
//
//  Created by Bradley Yin on 2/6/21.
//  Copyright © 2021 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift
import UIKit.UIImage

final class GoalCellViewModel {
    private var goal: Goal

    var title: String {
        return goal.name
    }

    var icon: UIImage? {
        if goal.iconImageName.isEmpty {
            return UIImage(named: "category_uncategorized")
        } else {
            return UIImage(named: goal.iconImageName)
        }
    }

    var remainingMoneyText: String {
        let totalExpense = goal.expenses.map({$0.amount}).reduce(0, +)
        let remainAmount = goal.totalAmount - totalExpense
        return String(format: "%.2f", remainAmount)
    }

    var totalExpenseText: String {
        let totalExpense = goal.expenses.map({$0.amount}).reduce(0, +)
        return String(format: "%.2f", totalExpense)
    }

    var totalMoneyText: String {
        return "Budget: " + String(format: "%.2f", goal.totalAmount)
    }

    var numberOfTransactionText: String {
        let count = goal.expenses.count
        if count > 1 {
            return "\(count) transactions"
        } else {
            return "\(count) transaction"
        }
    }

    var percentText: String {
        let totalExpense = goal.expenses.map({$0.amount}).reduce(0, +)
        let percent = (totalExpense / goal.totalAmount * 100).rounded()
        return "\(percent)%"
    }

    var percent: Double {
        let totalExpense = goal.expenses.map({$0.amount}).reduce(0, +)
        let percent = (totalExpense / goal.totalAmount * 100).rounded()
        return min(percent, 1.0)
    }

    init(goal: Goal) {
        self.goal = goal
    }
}
