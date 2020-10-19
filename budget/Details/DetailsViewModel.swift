//
//  DetailsViewModel.swift
//  budget
//
//  Created by Bradley Yin on 10/9/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift

final class DetailsViewModel: NSObject {
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
    //var monthYear = ""

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
        fetchCategories()
        //self.monthYear = "\(currentYear)\(currentMonth)"

        Observable.combineLatest(income, categories).subscribe(onNext: { [weak self] incomeNotBudget in
            guard let self = self else { return }
            self.calcRemainingBudget()
        }).disposed(by: disposeBag)

        NotificationCenter.default.addObserver(self, selector: #selector(refreshCategories), name: NSNotification.Name(NotificationName.categoryAdded.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCategories), name: NSNotification.Name(NotificationName.categoryDeleted.rawValue), object: nil)
    }

    var numberOfCategory: Int {
        return categories.value.count
    }

    func refresh() {
        fetchIncomes()
        convertDate()
        getRemainingFunds()
        fetchCategories()
    }

    @objc func refreshCategories() {
        fetchCategories()
    }

    func cellViewModel(at indexPath: IndexPath) -> DetailsCategoryCellViewModel {
        let category = categories.value[indexPath.row]
        let viewModel = DetailsCategoryCellViewModel(category: category)
        return viewModel
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

    private func calcRemainingBudget() {
        var totalBudget = 0.0
        for category in self.categories.value {
            totalBudget += category.totalAmount
        }

        if let income = income.value {
            incomeNotBuget.accept(income - totalBudget)
        } else {
            incomeNotBuget.accept(nil)
        }
    }

    func getExpenses(of category: Category) -> [Expense] {
        return monthlyExpense.value.filter { $0.parentCategory == category }
    }

    func deleteCategory(at indexPath: IndexPath) {
        let category = categories.value[indexPath.row]
        dependency.budgetController.deleteCategory(category: category)
        fetchCategories()
    }
}
