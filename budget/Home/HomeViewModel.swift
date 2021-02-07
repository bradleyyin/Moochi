//
//  HomeViewModel.swift
//  budget
//
//  Created by Bradley Yin on 6/11/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift

final class HomeViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency

    let income = BehaviorRelay<Double?>(value: nil)
    let remainFund = BehaviorRelay<Double?>(value: nil)
    let currentDate = BehaviorRelay<String?>(value: nil)
    let categories = BehaviorRelay<[Category]>(value: [])
    let incompleteGoals = BehaviorRelay<Results<Goal>?>(value: nil)
    let monthlyExpense = BehaviorRelay<[Expense]>(value: [])
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchIncomes()
        convertDate()
        getRemainingFunds()
        fetchCategories()
        fetchIncompleteGoals()
    }

    var numberOfCategory: Int {
        return categories.value.count
    }

    var remainingBalanceText: String {
        if let remainFund = remainFund.value {
            return "Remaining Balance"
        } else {
            return "Tap to add income"
        }
    }

    var remainingBalanceNumberText: String {
        if let remainFund = remainFund.value {
            let num = String(format: "%.2f", remainFund)
            return "$\(num)"
        } else {
            return "$0.00"
        }
    }

    func refresh() {
        fetchIncomes()
        convertDate()
        getRemainingFunds()
        fetchCategories()
        fetchIncompleteGoals()
    }
    
    private func fetchIncomes() {
        let realmIncomes = dependency.budgetController.readMonthlyIncomes().map { $0.amount }
        let totalIncome = realmIncomes.reduce(0, +)
        self.income.accept(totalIncome)
    }
    
    private func convertDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        currentDate.accept(formatter.string(from: Date()))
    }

    private func getRemainingFunds() {
        guard let income = income.value else { return }
        let expenses = dependency.budgetController.readMonthlyExpense()
        remainFund.accept(dependency.budgetCalculator.calculateRemainingFunds(totalIncome: income, expenses: expenses))
    }
    
    private func fetchCategories() {
        let realmCategories = dependency.budgetController.readMonthlyCategories()
        categories.accept(realmCategories)
    }

    private func fetchIncompleteGoals() {
        let goals = dependency.budgetController.readIncompleteGoals()
        incompleteGoals.accept(goals)
    }
    
    private func fetchExpenses() {
        monthlyExpense.accept(dependency.budgetController.readMonthlyExpense())
    }
    
    func getExpenses(of category: Category) -> [Expense] {
        return monthlyExpense.value.filter { $0.parentCategory == category }
    }
}
