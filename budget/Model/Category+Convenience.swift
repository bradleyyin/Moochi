//
//  Category+Convenience.swift
//  budget
//
//  Created by Bradley Yin on 10/2/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import CoreData

extension Category {
    @discardableResult convenience init(name: String, totalAmount: Double, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.name = name
        self.totalAmount = totalAmount
    }
}
