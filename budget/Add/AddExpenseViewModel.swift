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
    let name = BehaviorRelay<String?>(value: nil)
    let amount = BehaviorRelay<Double?>(value: nil)
    let date = BehaviorRelay<Date?>(value: nil)
    let category = BehaviorRelay<Category?>(value: nil)

    var expense: Expense?
    var categories: [Category] = []
    var selectedCategory: String = "uncategorized"
    //var date: Date?
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
        return name.value
    }

    var expenseDateText: String? {
        if let date = date.value {
            let dateString = formatter.string(from: date)
            return dateString
        } else {
            return nil
        }
    }

    var expenseAmountText: String? {
        if let amount = amount.value, amount != 0 {
            return "\(amount)"
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
        super.init()
        setupWithExpense(expense)
        fetchCategories()
        formatter.dateFormat = "yyyy.MM.dd"
    }

    func refresh() {
        fetchCategories()
    }

    func updateAmount(string: String) {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if !string.isEmpty {
            amountTypedString += string
            let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
            let newString = formatter.string(from: decNumber)!
            amount.accept(Double(newString))
        } else {
            amountTypedString = String(amountTypedString.dropLast())
            if !amountTypedString.isEmpty {
                let decNumber = NSDecimalNumber(string: amountTypedString).multiplying(by: 0.01)
                let newString = formatter.string(from: decNumber)!
                amount.accept(Double(newString))
            } else {
                amount.accept(0.0)
            }
        }
    }

    func updateDate(_ date: Date) {
        self.date.accept(date)
    }

    private func setupWithExpense(_ expense: Expense?) {
        self.expense = expense
        self.name.accept(expense?.name)
        self.amount.accept(expense?.amount)
        self.date.accept(expense?.date)
    }

    private func fetchCategories() {
        let categories = dependency.budgetController.readCategories()
        self.categories = categories
        print(categories.count, "herer")
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
