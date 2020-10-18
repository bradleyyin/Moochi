//
//  AddExpenseViewModel.swift
//  budget
//
//  Created by Bradley Yin on 9/7/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
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
    let note = BehaviorRelay<String?>(value: nil)

    var expense: Expense?
    var categories: [Category] = []

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

    var expenseCategoryText: String? {
        if let category = category.value {
            return "\(category.name)"
        } else {
            return "Uncategorized"
        }
    }

    var expenseCategory: Category? {
        return expense?.parentCategory
    }

    var noteHeight: CGFloat {
        let emptySize = "note".boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 189, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: FontPalette.font(size: 17, fontType: .light)], context: nil)
        guard let note = note.value else { return emptySize.height }
        let estimatedSize = note.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 189, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: FontPalette.font(size: 17, fontType: .light)], context: nil)
        return min(estimatedSize.height, 100)
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

    func updateName(string: String) {
        if !string.isEmpty {
            let temp = name.value ?? ""
            name.accept(temp + string)
        } else {
            let temp = name.value ?? ""
            name.accept(String(temp.dropLast()))
        }
    }

    func updateDate(_ date: Date) {
        self.date.accept(date)
    }

    func updateNote(_ note: String) {
        self.note.accept(note)
    }

    func selectCategory(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.category.accept(nil)
        } else {
            let adjustedIndex = indexPath.row - 1
            let category = categories[adjustedIndex]
            self.category.accept(category)
        }
    }

    func viewModelForCell(at indexPath: IndexPath) -> CategorySelectionCellViewModel {
        if indexPath.row == 0 {
            let viewModel = CategorySelectionCellViewModel(category: nil, isSelected: self.category.value == nil)
            return viewModel
        } else {
            let adjustedIndex = indexPath.row - 1
            let category = categories[adjustedIndex]
            let viewModel = CategorySelectionCellViewModel(category: category, isSelected: category == self.category.value)
            return viewModel
        }
    }

    func confirmExpense() {
        if let expense = expense {

        } else {
            let name = self.name.value ?? ""
            let amount = self.amount.value ?? 0
            let date = self.date.value ?? Date()
            let category = self.category.value
            let image = self.recieptImage.value
            dependency.budgetController.createNewExpense(name: name, amount: amount, date: date, category: category, image: image)
        }
    }

    func deleteExpense() {
        if let expense = expense {
            dependency.budgetController.deleteExpense(expense: expense)
        }
    }

    private func setupWithExpense(_ expense: Expense?) {
        self.expense = expense
        self.name.accept(expense?.name)
        self.amount.accept(expense?.amount)
        self.date.accept(expense?.date)
        self.note.accept(expense?.note)
    }

    private func fetchCategories() {
        let categories = dependency.budgetController.readCategories()
        self.categories = categories
//        dependency.budgetController.createCategory(name: "Travel", totalAmount: 500, isGoal: false)
//        dependency.budgetController.createCategory(name: "Game", totalAmount: 200, isGoal: false)
//        dependency.budgetController.createCategory(name: "Japan", totalAmount: 300, isGoal: true)
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
