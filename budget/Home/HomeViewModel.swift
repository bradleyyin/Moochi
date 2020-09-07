//
//  HomeViewModel.swift
//  budget
//
//  Created by Bradley Yin on 6/11/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxRealm
import RxSwift

final class HomeViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency

    let income = BehaviorRelay<Double?>(value: nil)
    let remainFund = BehaviorRelay<Double?>(value: nil)
    let currentDate = BehaviorRelay<String?>(value: nil)
    let categories = BehaviorRelay<[Category]>(value: [])
    let goals = BehaviorRelay<[Category]>(value: [])
    let monthlyExpense = BehaviorRelay<[Expense]>(value: [])
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchIncomes()
        convertDate()
        getRemainingFunds()
    }

    func refresh() {
        fetchIncomes()
        convertDate()
        getRemainingFunds()
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
        let realmCategories = dependency.budgetController.readCategories()
        categories.accept(realmCategories.filter { !$0.isGoal })
        goals.accept(realmCategories.filter { $0.isGoal })
    }
    
    private func fetchExpenses() {
        monthlyExpense.accept(dependency.budgetController.readMonthlyExpense())
    }
    
    func getExpenses(of category: Category) -> [Expense] {
        return monthlyExpense.value.filter { $0.parentCategory == category }
    }
}
