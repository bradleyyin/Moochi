//
//  CalendarViewModel.swift
//  budget
//
//  Created by Bradley Yin on 11/15/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift

final class CalendarViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    var currentMonth: Int {
        let date = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        return currentMonth
    }

    var currentYear: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }

    var amountTypedString = ""

    let income = BehaviorRelay<Double?>(value: nil)
    let incomeNotBuget = BehaviorRelay<Double?>(value: nil)
    let remainFund = BehaviorRelay<Double?>(value: nil)
    let currentDate = BehaviorRelay<String?>(value: nil)
    let categories = BehaviorRelay<[Category]>(value: [])
    let goals = BehaviorRelay<[Category]>(value: [])
    let monthlyExpense = BehaviorRelay<[Expense]>(value: [])

    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchIncomes()

        //add notidfication for adding expense
    }

    var numberOfCategory: Int {
        return categories.value.count
    }

    func refresh() {
        fetchIncomes()
        convertDate()
    }

    private func convertDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        currentDate.accept(formatter.string(from: Date()))
    }

    private func fetchExpenses() {
        monthlyExpense.accept(dependency.budgetController.readMonthlyExpense())
    }

    func getExpenses(of category: Category) -> [Expense] {
        return monthlyExpense.value.filter { $0.parentCategory == category }
    }
}
