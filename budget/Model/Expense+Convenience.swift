//
//  Expense+Convenience.swift
//  budget
//
//  Created by Bradley Yin on 10/2/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

extension Expense {
    @discardableResult convenience init(name: String, imagePath: String?, date: Date, category: Category?, amount: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext)
    {
        self.init(context: context)
        self.name = name
        self.imagePath = imagePath
        self.date = date
        self.amount = amount
        self.parentCategory = category
    }
}
