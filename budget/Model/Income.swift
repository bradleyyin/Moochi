//
//  Income.swift
//  budget
//
//  Created by Bradley Yin on 6/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import RealmSwift

class Income: Object {
    @objc dynamic var monthYear = ""
    @objc dynamic var amount: Double = 0
}
