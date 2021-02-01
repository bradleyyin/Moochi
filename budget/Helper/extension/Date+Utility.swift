//
//  Date+Utility.swift
//  budget
//
//  Created by Bradley Yin on 10/11/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation

//get first day of the month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
    }
    
    // This Month Start
    func getThisMonthStart() -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }
    
    func getThisMonthEnd() -> Date {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents)!
    }

    func getTodayStart() -> Date? {
        var component = Calendar.current.dateComponents([.year, .month, .day], from: self)
        component.hour = 0
        return Calendar.current.date(from: component)
    }

    func getTodayEnd() -> Date? {
        var component = Calendar.current.dateComponents([.year, .month, .day], from: self)
        component.hour = 24
        return Calendar.current.date(from: component)
    }

    func numberOfMonthAgo(numberOfMonth: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: -numberOfMonth, to: self)!
    }
    
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow: Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
