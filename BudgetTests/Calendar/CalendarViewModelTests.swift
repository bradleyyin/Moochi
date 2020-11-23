//
//  CalendarViewModelTests.swift
//  BudgetTests
//
//  Created by Bradley Yin on 11/22/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import XCTest
import RealmSwift
@testable import budget

class CalendarViewModelTests: XCTestCase {
    var realm: Realm!
    var viewModel: CalendarViewModel!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration =
            Realm.Configuration(inMemoryIdentifier: UUID().uuidString)

        realm = try! Realm()
        let category1 = Category()
        category1.name = "category1"
        category1.totalAmount = 100
        category1.isGoal = false
        try! realm.write {
            realm.add(category1)
        }
        let expense1 = Expense()
        expense1.name = "expense1"
        expense1.date = Date()
        expense1.parentCategory = category1
        try! realm.write {
            realm.add(expense1)
        }
        let expense2 = Expense()
        expense2.name = "expense2"
        expense2.date = Date()
        expense2.parentCategory = category1
        try! realm.write {
            realm.add(expense1)
        }
        viewModel = CalendarViewModel(dependency: AppDependency())
    }

    func testSuccessfulInit() {
        viewModel.selectedDate.accept(Date(timeIntervalSince1970: 1606102868)) //11/22/2020 Sunday
        XCTAssertEqual(viewModel.selectedMonth, 11)
        XCTAssertEqual(viewModel.selectedDay, 22)
        XCTAssertEqual(viewModel.selectedWeekday, 1) // 1 is sunday
        XCTAssertEqual(viewModel.selectedDate.value, Date())

    }
}
