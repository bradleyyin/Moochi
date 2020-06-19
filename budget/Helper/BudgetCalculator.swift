//
//  BudgetCalculator.swift
//  budget
//
//  Created by Bradley Yin on 10/6/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

protocol HasBudgetCalculator {
    var budgetCalculator: BudgetCalculator { get }
}

class BudgetCalculator {
    func calculateRemainingFunds(totalIncome: Double, expenses: [Expense]) -> Double {
        var remain = totalIncome
        for expense in expenses{
            remain -= expense.amount
        }
        return remain
    }
}
