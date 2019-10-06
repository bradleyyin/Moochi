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
    
    func createNewExpense(name: String,
                          amount: Double,
                          date: Date,
                          category: String,
                          image: UIImage?,
                          context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        var imagePath: String?
        if let image = image {
            imagePath = imageSaver.saveImage(image: image)
        }
        context.performAndWait {
            Expense(name: name, imagePath: imagePath, date: date, category: category.uppercased(), amount: amount)
            saveToPersistentData()
        }
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
    
    func createCategory(name: String, totalAmount: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            Category(name: name, totalAmount: totalAmount)
            saveToPersistentData()
        }
    }
    
    func deleteCategory(category: Category, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            context.delete(category)
            saveToPersistentData()
        }
    }
    
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
