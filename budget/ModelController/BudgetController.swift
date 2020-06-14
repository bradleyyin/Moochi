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
            category?.expenses.insert(expense)
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
//        return expenses
//    }
    
    func readMonthlyExpense() -> [Expense] {
        let currentDate = Date()
        let startOfMonth = currentDate.getThisMonthStart()
        let endOfMonth = currentDate.getThisMonthEnd()
        var expenses: [Expense] = []
        let results = realm.objects(Expense.self).filter("(date => %@) AND (date <= %@)", startOfMonth as NSDate, endOfMonth as NSDate)
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
}

//- MARK: income
extension BudgetController {
    func createIncome(amount: Double, monthYear: String) {
        let income = Income()
        income.amount = amount
        income.monthYear = monthYear
        try! realm.write {
            realm.add(income)
        }
    }
    
    func readIncome(monthYear: String) -> Income? {
        var income: Income?
        income = realm.objects(Income.self).filter("monthYear == %@", monthYear).first
        return income
    }
    
    func updateIncome(income: Income, amount: Double) {
        try! realm.write {
            income.amount = amount
        }
    }
}

//- MARK: category
extension BudgetController {
    func createCategory(name: String, totalAmount: Double, isGoal: Bool) {
        let category = Category()
        category.name = name
        category.totalAmount = totalAmount
        category.isGoal = isGoal
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
    
    func updateCategory(category: Category, name: String, totalAmount: Double) {
        try! realm.write {
            category.name = name
            category.totalAmount = totalAmount
        }
    }
    
    func deleteCategory(category: Category) {
        try! realm.write {
            realm.delete(category)
        }
    }
}
