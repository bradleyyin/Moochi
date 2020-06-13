//
//  HomeViewModel.swift
//  budget
//
//  Created by Bradley Yin on 6/11/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift

final class HomeViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency

    let income = BehaviorRelay<Income?>(value: nil)
    let remainFund = BehaviorRelay<Double?>(value: nil)
    let currentDate = BehaviorRelay<String?>(value: nil)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchIncome()
        convertDate()
    }

    func refresh() {
        fetchIncome()
        convertDate()
    }
    
    private func fetchIncome() {
        income.accept(dependency.budgetController.readIncome(monthYear: dependency.monthCalculator.monthYear))
    }
    
    private func convertDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        currentDate.accept(formatter.string(from: Date()))
    }

    private func getRemainingFunds() {
        guard let income = income.value else { return }
        let expenses = dependency.budgetController.readMonthlyExpense()
        remainFund.accept(dependency.budgetCalculator.calculateRemainingFunds(income: income, expenses: expenses))
    }
}
