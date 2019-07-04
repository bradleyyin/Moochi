//
//  Category.swift
//  budget
//
//  Created by Bradley Yin on 7/3/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
class Category {
    var categoryName : String?
    var totalBudget : Double?
    var remainingBudget : Double?
    
    init(categoryName: String, totalBudget: Double, remainingBudget : Double) {
        self.categoryName = categoryName
        self.totalBudget = totalBudget
        self.remainingBudget = remainingBudget
    }
    
}
