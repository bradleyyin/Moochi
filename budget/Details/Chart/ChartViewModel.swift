//
//  ChartViewModel.swift
//  budget
//
//  Created by Bradley Yin on 10/11/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift

final class ChartViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency

    var category: Category
    //var expenses: [Expense] = []
    var expenses: Results<Expense>? = nil
    var expensesDictionary: [String: Double] = [:]
    var sortedKey: [String] = []
    var reversedKey: [String] = []

    //String
    var screenTitleText: String? {
        return category.name
    }

    init(category: Category, dependency: Dependency) {
        self.dependency = dependency
        self.category = category
        super.init()
        loadExpenses()
        //setupWithCategory(category)
    }

    func refresh() {

    }





    func viewModelForCell(at indexPath: IndexPath) -> ChartCellViewModel? {
        guard let expense = expenses?[indexPath.row] else { return nil }
        let cellViewModel = ChartCellViewModel(title: expense.name, date: expense.date, amount: expense.amount)
        return cellViewModel
    }

    func totalExpense(numberOfMonthPassed: Int) -> Double {
        let expenses = dependency.budgetController.readMonthlyExpense(of: category, numberOfMonthPassed: numberOfMonthPassed)
        let totalAmount = expenses.map({$0.amount}).reduce(0, +)
        return totalAmount
    }

    private func loadExpenses() {
        self.expenses = dependency.budgetController.readAllExpenses(of: category).sorted(byKeyPath: "date",ascending: false)
    }
}
