//
//  Income+Convenience.swift
//  budget
//
//  Created by Bradley Yin on 10/2/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

extension Income {
    @discardableResult convenience init(monthYear: String, amount: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.monthYear = monthYear
        self.amount = amount
    }
}
