//
//  Achievement.swift
//  budget
//
//  Created by Bradley Yin on 2/2/21.
//  Copyright © 2021 bradleyyin. All rights reserved.
//

import Foundation
import RealmSwift

class Achievement: Object {
    @objc dynamic var logExpenseDays: Int = 0
    @objc dynamic var categoryCount: Int = 0
    @objc dynamic var expenseCount: Int = 0
    @objc dynamic var goalCompleteCount: Int = 0
    @objc dynamic var incomeAdded: Double = 0
    @objc dynamic var receiptCount: Int = 0
}
