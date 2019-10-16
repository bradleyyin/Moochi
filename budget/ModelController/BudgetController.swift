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

class BudgetController {
    let imageSaver = ImageSaver()
    
    func saveToPersistentData(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("error saving to persistent data : \(error)")
            }
        }
    }
}

//- MARK: expense
extension BudgetController {
    func createNewExpense(name: String,
                          amount: Double,
                          date: Date,
                          category: Category?,
                          image: UIImage?,
                          context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        var imagePath: String?
        if let image = image {
            imagePath = imageSaver.saveImage(image: image)
        }
        context.performAndWait {
            Expense(name: name, imagePath: imagePath, date: date, category: category, amount: amount)
            saveToPersistentData()
        }
    }
    
    func readMonthlyExpense(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> [Expense] {
        let currentDate = Date()
        let startOfMonth = currentDate.getThisMonthStart()
        let endOfMonth = currentDate.getThisMonthEnd()
        var expenses: [Expense] = []
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.predicate = NSPredicate(format: "(date => %@) AND (date <= %@)", startOfMonth as NSDate, endOfMonth as NSDate)
        context.performAndWait {
            do {
                expenses = try context.fetch(request)
            } catch {
                print("error loading income")
            }
        }
        return expenses
    }
    
    func updateExpense(expense: Expense, imagePath: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            expense.imagePath = imagePath
            saveToPersistentData()
        }
    }
    
    func deleteExpense(expense: Expense, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            context.delete(expense)
            saveToPersistentData()
        }
    }
}
//- MARK: income
extension BudgetController {
    func createIncome(amount: Double, monthYear: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            Income(monthYear: monthYear, amount: amount)
            saveToPersistentData()
        }
    }
    
    func readIncome(monthYear: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Income? {
        var income: Income?
        context.performAndWait {
            let request: NSFetchRequest<Income> = Income.fetchRequest()
            let predicate = NSPredicate(format: "monthYear == %@", monthYear)
            request.predicate = predicate
            
            do {
                income = try context.fetch(request).first
            } catch {
                fatalError("Error loading income: \(error)")
            }
        }
        return income
    }
    
    func updateIncome(income: Income, amount: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            income.amount = amount
            saveToPersistentData()
        }
    }
}

//- MARK: category
extension BudgetController {
    func createCategory(name: String, totalAmount: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            Category(name: name, totalAmount: totalAmount)
            saveToPersistentData()
        }
    }
    func readCategories(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> [Category] {
        var categories: [Category] = []
        context.performAndWait {
            let request: NSFetchRequest<Category> = Category.fetchRequest()
            do {
                categories = try context.fetch(request)
            } catch {
                print("error loading categories: \(error)")
            }
        }
        return categories
    }
    
    func deleteCategory(category: Category, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            context.delete(category)
            saveToPersistentData()
        }
    }
}
