//
//  AddExpenseViewModelTests.swift
//  BudgetTests
//
//  Created by Bradley Yin on 9/7/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import XCTest
import RealmSwift
@testable import budget

class AddExpenseViewModelTests: XCTestCase {
    var realm: Realm!
    var viewModel: AddExpenseViewModel!

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
        viewModel = AddExpenseViewModel(expense: nil, dependency: AppDependency())
    }

    func testSuccessfulInit() {
        XCTAssertEqual(viewModel.categories.count, 1)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM dd"
//        XCTAssertEqual(viewModel.currentDate.value, formatter.string(from: Date()))
//        XCTAssertEqual(viewModel.remainFund.value, 5000.00)
//        XCTAssertEqual(viewModel.categories.value.count, 1)
    }

    func testPropertiesWithNoExpense() {
        viewModel.expense = nil
        XCTAssertEqual(viewModel.screenTitleText, "edit entry")
        XCTAssertEqual(viewModel.expenseNameText, "edit entry")
        XCTAssertEqual(viewModel.expenseAmountText, "edit entry")
        XCTAssertEqual(viewModel.expenseDateText, "edit entry")
        //XCTAssertEqual(viewModel.remainingBalanceNumberText, "$5000.00")
    }
}
