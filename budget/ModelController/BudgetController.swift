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
    
    func createNewExpense(name: String, amount: Double, date: Date, category: String, image: UIImage?) {
        var imagePath : String?
        if let image = image{
            imagePath = imageSaver.saveImage(image: image)
        }
        Expense(name: name, imagePath: imagePath, date: date, category: category.uppercased(), amount: amount)
        saveToPersistentData()
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
