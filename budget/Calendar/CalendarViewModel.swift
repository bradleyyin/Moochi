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

    var selectedMonth: Int {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: selectedDate.value)
        return currentMonth
    }

    var selectedDay: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: selectedDate.value)
    }

    var selectedWeekday: Int {
        let calendar = Calendar.current
        return calendar.component(.weekday, from: selectedDate.value)
    }

    let monthlyExpense = BehaviorRelay<[Expense]>(value: [])
    let selectedDate = BehaviorRelay<Date>(value: Date())
    let expensesOfDay = BehaviorRelay<[Int : [Expense]]>(value: [:])

    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchExpenses()
    }

    private func fetchExpenses() {
        monthlyExpense.accept(dependency.budgetController.readMonthlyExpense())
    }

    func getExpenses(of category: Category) -> [Expense] {
        return monthlyExpense.value.filter { $0.parentCategory == category }
    }

    func getExpenses(of date: Date) -> [Expense] {
        print(self.selectedDate.value)
        return monthlyExpense.value.filter { $0.date == date }
    }
}
