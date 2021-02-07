//
//  BudgetController.swift
//  budget
//
//  Created by Bradley Yin on 10/2/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import RealmSwift

protocol HasBudgetController {
    var budgetController: BudgetController { get }
}

class BudgetController {
    let imageSaver = ImageSaver()
    let realm = try! Realm()
}

//- MARK: expense
extension BudgetController {
    func createNewExpense(name: String,
                          amount: Double,
                          date: Date,
                          category: Category?,
                          image: UIImage?) {
        var imagePath: String?
        if let image = image {
            imagePath = imageSaver.saveImage(image: image)
        }
        let expense = Expense()
        expense.name = name
        expense.amount = amount
        expense.date = date
        expense.parentCategory = category
        expense.imagePath = imagePath
        try! realm.write {
            realm.add(expense)
            category?.expenses.append(expense)
        }
    }
    
//    func readAllExpenses(of category: Category, context:NSManagedObjectContext = CoreDataStack.shared.mainContext) -> [Expense] {
//        var expenses: [Expense] = []
//        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
//        request.predicate = NSPredicate(format: "parentCategory == %@", category)
//        context.performAndWait {
//            do {
//                expenses = try context.fetch(request)
//            } catch {
//                print("error loading all expenses")
//            }
//        }
//
//
//        var expenses: [Expense] = []
//        let results = realm.objects(Expense.self).filter("parentCategory == %@", category).
//        expenses = Array(results)
//        return expenses
//    }

    func readAllExpenses(of category: Category) -> Results<Expense> {
        let results = realm.objects(Expense.self).filter("parentCategory == %@", category)
        return results
    }
    
    func readMonthlyExpense() -> [Expense] {
        let currentDate = Date()
        let startOfMonth = currentDate.getThisMonthStart()
        let endOfMonth = currentDate.getThisMonthEnd()
        var expenses: [Expense] = []
        let results = realm.objects(Expense.self).filter("(date => %@) AND (date <= %@)", startOfMonth as NSDate, endOfMonth as NSDate)
        expenses = Array(results)
        return expenses
    }

    func readMonthlyExpense(of category: Category, numberOfMonthPassed: Int) -> [Expense] {
        let targetDate = Date().numberOfMonthAgo(numberOfMonth: numberOfMonthPassed)
        let startOfMonth = targetDate.getThisMonthStart()
        let endOfMonth = targetDate.getThisMonthEnd()
        var expenses: [Expense] = []
        let results = realm.objects(Expense.self).filter("(date => %@) AND (date <= %@) AND parentCategory == %@", startOfMonth as NSDate, endOfMonth as NSDate, category)
        expenses = Array(results)
        return expenses
    }

    func readDailyExpense(of date: Date) -> [Expense] {
        guard let startOfToday = date.getTodayStart(), let endOfToday = date.getTodayEnd() else { return [] }

        var expenses: [Expense] = []
        let results = realm.objects(Expense.self).filter("(date => %@) AND (date <= %@)", startOfToday as NSDate, endOfToday as NSDate)
        expenses = Array(results)
        return expenses
    }
    
    func updateExpense(expense: Expense, imagePath: String) {
        try! realm.write {
            expense.imagePath = imagePath
        }
    }
    func updateExpense(expense: Expense,
                       name: String,
                       amount: Double,
                       date: Date,
                       category: Category?,
                       image: UIImage?) {
        var imagePath: String?
        if let image = image {
            imagePath = imageSaver.saveImage(image: image)
        }
        try! realm.write {
            expense.name = name
            expense.amount = amount
            expense.date = date
            expense.parentCategory = category
            expense.imagePath = imagePath
        }
    }
    
    func deleteExpense(expense: Expense) {
        try! realm.write {
            realm.delete(expense)
        }
    }

    func searchExpense(keyword: String) -> [Expense] {
        var expenses: [Expense] = []
        let results = realm.objects(Expense.self).filter("name BEGINSWITH[c] %@", keyword as NSString)
        expenses = Array(results)
        return expenses
    }
}

//- MARK: income
extension BudgetController {
    func createIncome(amount: Double, date: Date) {
        let income = Income()
        income.amount = amount
        income.date = date
        try! realm.write {
            realm.add(income)
        }
    }
    
    func readMonthlyIncomes() -> [Income] {
        let currentDate = Date()
        let startOfMonth = currentDate.getThisMonthStart()
        let endOfMonth = currentDate.getThisMonthEnd()
        var incomes: [Income] = []
        let results = realm.objects(Income.self).filter("(date => %@) AND (date <= %@)", startOfMonth as NSDate, endOfMonth as NSDate)
        incomes = Array(results)
        return incomes
    }
}

//- MARK: category
extension BudgetController {
    func createCategory(name: String, totalAmount: Double, iconName: String) {
        let category = Category()
        category.name = name
        category.totalAmount = totalAmount
        category.iconImageName = iconName
        try! realm.write {
            realm.add(category)
        }
    }
    
    func readCategories() -> [Category] {
        var categories: [Category] = []
        let results = realm.objects(Category.self)
        categories = Array(results)
        return categories
    }

    func readGoals() -> [Category] {
        var categories: [Category] = []
        let isGoal = true
        let results = realm.objects(Category.self).filter("isGoal == %@", isGoal)
        categories = Array(results)
        return categories
    }

    func readMonthlyCategories() -> [Category] {
        let currentDate = Date()
        let startOfMonth = currentDate.getThisMonthStart()
        let endOfMonth = currentDate.getThisMonthEnd()
        var categories: [Category] = []
        let results = realm.objects(Category.self).filter("(date => %@) AND (date <= %@)", startOfMonth as NSDate, endOfMonth as NSDate)
        categories = Array(results)
        if categories.isEmpty {
            //load last month's category
            let lastMonthToday = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            let startOfLastMonth = lastMonthToday.getThisMonthStart()
            let endOfLastMonth = lastMonthToday.getThisMonthEnd()
            let lastMonthResults = realm.objects(Category.self).filter("(date => %@) AND (date <= %@)", startOfLastMonth as NSDate, endOfLastMonth as NSDate)

            // put last month category into this month
            let lastMonthCategories = Array(lastMonthResults)
            for category in lastMonthCategories {
                createCategory(name: category.name, totalAmount: category.totalAmount, iconName: category.iconImageName)
            }

            return lastMonthCategories
        }

        return categories
    }
    
    func updateCategory(category: Category, name: String, totalAmount: Double, iconName: String) {
        try! realm.write {
            category.name = name
            category.totalAmount = totalAmount
            category.iconImageName = iconName
        }
    }
    
    func deleteCategory(category: Category) {
        try! realm.write {
            realm.delete(category)
        }
    }

    //MARK: Goal
    func readIncompleteGoals() -> Results<Goal> {
        let results = realm.objects(Goal.self).filter("isCompleted == %@", false)
        return results
    }

    func readCompleteGoals() -> Results<Goal> {
        let results = realm.objects(Goal.self).filter("isCompleted == %@", true)
        return results
    }
}
