//
//  AddCategoriesViewModel.swift
//  budget
//
//  Created by Bradley Yin on 10/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift

final class AddCategoriesViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency

    let name = BehaviorRelay<String?>(value: nil)
    let amount = BehaviorRelay<Double?>(value: nil)
    let currentSelectedIconNumber = BehaviorRelay<Int?>(value: nil)

    var category: Category?

    //var date: Date?
    var amountTypedString = ""
    //String
    var screenTitleText: String {
        if category != nil  {
            return "Edit Category"
        } else {
            return "Add Category"
        }
    }

    var expenseNameText: String? {
        return name.value
    }

    var expenseAmountText: String? {
        if let amount = amount.value, amount != 0 {
            return "\(amount)"
        } else {
            return nil
        }
    }

    init(category: Category?, dependency: Dependency) {
        self.dependency = dependency
        super.init()
        setupWithCategory(category)
    }

    func refresh() {

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

    func selectCategory(at indexPath: IndexPath) {
        self.currentSelectedIconNumber.accept(indexPath.row)
    }

    func viewModelForCell(at indexPath: IndexPath) -> CategoryIconCellViewModel{
        let cellViewModel = CategoryIconCellViewModel(index: indexPath.row, isSelected: self.currentSelectedIconNumber.value == indexPath.row)
        return cellViewModel
    }

    func confirmCategory() {
        let name = self.name.value ?? ""
        let amount = self.amount.value ?? 0
        var iconName = ""
        if let number = currentSelectedIconNumber.value {
            iconName = "category\(number)"
        }

        if let category = category {
            dependency.budgetController.updateCategory(category: category, name: name, totalAmount: amount, iconName: iconName)
        } else {
            dependency.budgetController.createCategory(name: name, totalAmount: amount, iconName: iconName)
        }

        NotificationCenter.default.post(name: Notification.Name(NotificationName.categoryAdded.rawValue), object: nil)
    }

//    func deleteExpense() {
//        if let expense = expense {
//            dependency.budgetController.deleteExpense(expense: expense)
//        }
//    }

    private func setupWithCategory(_ category: Category?) {
        self.category = category
        self.name.accept(category?.name)
        self.amount.accept(category?.totalAmount)
        var tempNumberString = category?.iconImageName
        tempNumberString?.removeFirst(8)
        let number = Int(tempNumberString ?? "") ?? 0
        self.currentSelectedIconNumber.accept(number)
    }
}
