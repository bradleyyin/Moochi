//
//  CalendarExpenseCellViewModel.swift
//  budget
//
//  Created by Bradley Yin on 1/29/21.
//  Copyright © 2021 bradleyyin. All rights reserved.
//

import Foundation

struct CalendarExpenseCellViewModel {
    let expense: Expense

    var name: String? {
        return expense.name
    }

    var amountText: String? {
        return "\(expense.amount)"
    }

    var dateText: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return "\(dateFormatter.string(from: expense.date))"
    }

    var category: String? {
        return expense.parentCategory?.name
    }
}
