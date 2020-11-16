//
//  Category.swift
//  budget
//
//  Created by Bradley Yin on 6/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name = ""
    @objc dynamic var totalAmount: Double = 0.0
    let expenses = List<Expense>()
    @objc dynamic var isGoal: Bool = false
    @objc dynamic var iconImageName = ""
    @objc dynamic var date: Date = Date()
}
