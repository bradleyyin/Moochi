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

//    var selectedMonth: Int {
//        let calendar = Calendar.current
//        let currentMonth = calendar.component(.month, from: selectedDate.value)
//        return currentMonth
//    }

//    var selectedDay: Int {
//        let calendar = Calendar.current
//        return calendar.component(.day, from: selectedDate.value)
//    }

//    var selectedWeekday: Int {
//        let calendar = Calendar.current
//        return calendar.component(.weekday, from: selectedDate.value)
//    }

    //let monthlyExpense = BehaviorRelay<[Expense]>(value: [])
    //let monthlyGoal = BehaviorRelay<[Expense]>(value: [])
    let currentDate = BehaviorRelay<Date>(value: Date())
    let today = Date()
    //let expensesOfDay = BehaviorRelay<[Int : [Expense]]>(value: [:])

    var monthsArr = ["July", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "July", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun"]

    var currentMonthIndex: Int = Calendar.current.component(.month, from: Date()) - 1 + 6


    var currentMonthDisplayIndex: Int {
        let month = monthsArr[currentMonthIndex]
        let index = monthArrayToDisplay.firstIndex(of: month) ?? 0
        return index
    }

    var monthArrayToDisplay: [String] {
        let currentMonthIndex = Calendar.current.component(.month, from: today) - 1 + 6

        let indexSixMonthAgo = currentMonthIndex - 6
        let indexFiveMonthAhead = currentMonthIndex + 5
        let array = Array(monthsArr[indexSixMonthAgo...indexFiveMonthAhead])
        return array
    }

    //var currentDate = Date()
    var currentDay: Int {
        return Calendar.current.component(.day, from: currentDate.value)
    }

    var currentMonth: Int {
        return Calendar.current.component(.month, from: currentDate.value)
    }

    var currentYear: Int {
        return Calendar.current.component(.year, from: currentDate.value)
    }

    var numOfDaysInMonth: [Int] {
        //leap year
        if currentMonth == 2 && currentYear % 4 == 0 {
            return [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        } else {
            return [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
        }
    }
//    var presentedMonthIndex = 0
//    var presentedYear = 0
    var firstWeekDayOfMonth: Int {
        let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
        //return day == 7 ? 1 : day
        return day
    }   //(Sunday-Saturday 1-7)

    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        //fetchExpenses()
    }
//
//    private func fetchExpenses() {
//        monthlyExpense.accept(dependency.budgetController.readMonthlyExpense())
//    }
//
//    func getExpenses(of category: Category) -> [Expense] {
//        return monthlyExpense.value.filter { $0.parentCategory == category }
//    }
//
//    func getExpenses(of date: Date) -> [Expense] {
//        return monthlyExpense.value.filter { $0.date == date }
//    }
}
