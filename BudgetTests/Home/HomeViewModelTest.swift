//
//  HomeViewModelTest.swift
//  BudgetTests
//
//  Created by Bradley Yin on 9/6/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import XCTest
import RealmSwift
@testable import budget

class HomeViewModelTest: XCTestCase {
    var realm: Realm!
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration =
            Realm.Configuration(inMemoryIdentifier: UUID().uuidString)

        //task = Task()
        realm = try! Realm()
        let income = Income()
        income.amount = 5000.00
        income.date = Date()
        let category1 = Category()
        category1.name = "category1"
        category1.totalAmount = 100
        category1.isGoal = false
        try! realm.write {
            //realm.add([task])
            realm.add(income)
            realm.add(category1)
        }
        viewModel = HomeViewModel(dependency: AppDependency())
    }

    func testSuccessfulInit() {
        XCTAssertEqual(viewModel.income.value, 5000.00)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        XCTAssertEqual(viewModel.currentDate.value, formatter.string(from: Date()))
        XCTAssertEqual(viewModel.remainFund.value, 5000.00)
        XCTAssertEqual(viewModel.categories.value.count, 1)
    }

    func testProperties() {
        XCTAssertEqual(viewModel.remainingBalanceText, "Remaining Balance")
        XCTAssertEqual(viewModel.remainingBalanceNumberText, "$5000.00")
    }
}
