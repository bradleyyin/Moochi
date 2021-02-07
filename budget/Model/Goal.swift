//
//  Goal.swift
//  budget
//
//  Created by Bradley Yin on 2/6/21.
//  Copyright © 2021 bradleyyin. All rights reserved.
//

import Foundation
import RealmSwift

class Goal: Object {
    @objc dynamic var name = ""
    @objc dynamic var totalAmount: Double = 0.0
    let expenses = List<Expense>()
    @objc dynamic var isCompleted: Bool = false
    //@objc dynamic var isGoal: Bool = false
    @objc dynamic var iconImageName = ""
    //@objc dynamic var date: Date = Date()
}
