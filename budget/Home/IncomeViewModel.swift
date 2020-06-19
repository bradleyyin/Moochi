//
//  IncomeViewModel.swift
//  budget
//
//  Created by Bradley Yin on 6/17/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxRealm
import RxSwift

final class IncomeViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency

    let income = BehaviorRelay<Double?>(value: nil)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchIncomes()
    }

    func refresh() {
        fetchIncomes()
    }
    
    private func fetchIncomes() {
        let realmIncomes = dependency.budgetController.readMonthlyIncomes().map { $0.amount }
        let totalIncome = realmIncomes.reduce(0, +)
        self.income.accept(totalIncome)
    }
    
    private func addIncome(with amount: Double) {
        dependency.budgetController.createIncome(amount: amount, date: Date())
    }
}
