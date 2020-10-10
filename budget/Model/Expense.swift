//
//  Expense.swift
//  budget
//
//  Created by Bradley Yin on 6/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import RealmSwift

class Expense: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var imagePath: String?
    @objc dynamic var date: Date = Date()
    @objc dynamic var amount: Double = 0
    @objc dynamic var parentCategory: Category?
}

