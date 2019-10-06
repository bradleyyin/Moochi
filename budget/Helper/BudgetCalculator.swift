//
//  BudgetCalculator.swift
//  budget
//
//  Created by Bradley Yin on 10/6/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

class BudgetCalculator {
    func calculateRemainingFunds(income: Income, expenses: [Expense]) -> Double {
        var remain = income.amount
        for expense in expenses{
            remain -= expense.amount
        }
        return remain
    }
}
