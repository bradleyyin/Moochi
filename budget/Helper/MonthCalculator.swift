//
//  Calculator.swift
//  budget
//
//  Created by Bradley Yin on 10/6/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

protocol HasMonthCalculator {
    var monthCalculator: MonthCalculator { get }
}

class MonthCalculator {
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var currentMonth: Int {
        let date = Date()
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        return currentMonth
    }
    
    var currentYear: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.year, from: date)
    }
    
    var currentDate: Int {
        let date = Date()
        let calendar = Calendar.current
        return calendar.component(.day, from: date)
    }
    
    var monthYear: String {
        "\(currentYear)\(currentMonth)"
    }
    
    var currentMonthString: String {
        monthsArr[currentMonth - 1]
    }
}
