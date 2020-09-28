//
//  AddExpenseViewModel.swift
//  budget
//
//  Created by Bradley Yin on 9/7/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxRealm
import RxSwift

final class AddExpenseViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency

    let formatter = DateFormatter()
    let recieptImage = BehaviorRelay<UIImage?>(value: nil)

    var expense: Expense?
    var categories: [Category] = []
    var selectedCategory: String = "uncategorized"
    var date: Date?
    var amountTypedString = ""

    //String
    var screenTitleText: String {
        if expense != nil  {
            return "Edit Entry"
        } else {
            return "Add"
        }
    }

    var expenseNameText: String? {
        return expense?.name
    }

    var expenseAmountText: String? {
        if let expense = expense {
            return "\(expense.amount)"
        } else {
            return nil
        }
    }

    var expenseDateText: String? {
        if let expense = expense {
            let dateString = formatter.string(from: expense.date)
            return dateString
        } else {
            return nil
        }
    }

    var expenseCategory: Category? {
        return expense?.parentCategory
    }

    var expenseNoteText: String? {
        if let expense = expense {
            let dateString = formatter.string(from: expense.date)
            return dateString
        } else {
            return nil
        }
    }

    init(expense: Expense?, dependency: Dependency) {
        self.dependency = dependency
        self.expense = expense
        super.init()
        fetchCategories()
        formatter.dateFormat = "MM/dd/yyyy"
    }

    func refresh() {
        fetchCategories()
    }

    private func fetchCategories() {
        let categories = dependency.budgetController.readCategories()
        self.categories = categories
    }

    private func fetchRecieptImage() {
        guard let expense = expense else { return }

        if let filePathComponent = expense.imagePath {
            let fm = FileManager.default
            guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

            let filePath = dir.appendingPathComponent(filePathComponent).path

            if FileManager.default.fileExists(atPath: filePath) {
                recieptImage.accept(UIImage(contentsOfFile: filePath))
            }
        } else {
            recieptImage.accept(UIImage(named: "addImage"))
        }
    }
}
