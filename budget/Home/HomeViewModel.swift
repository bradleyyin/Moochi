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

    let income = BehaviorRelay<Income?>(value: nil)
    let remainFund = BehaviorRelay<Double?>(value: nil)
    let currentDate = BehaviorRelay<String?>(value: nil)
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchAndBindIncome()
        convertDate()
    }

    func refresh() {
        fetchAndBindIncome()
        convertDate()
        getRemainingFunds()
    }
    
    private func fetchAndBindIncome() {
        let realmIncome = dependency.budgetController.readIncome(monthYear: dependency.monthCalculator.monthYear)
        self.income.accept(realmIncome)
        if let realmIncome = realmIncome {
            Observable.from(object: realmIncome).subscribe(onNext: { realmIncome in
                self.income.accept(realmIncome)
            })
        }
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
