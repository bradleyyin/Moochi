//
//  DetailsViewModelTests.swift
//  BudgetTests
//
//  Created by Bradley Yin on 10/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import XCTest
import RealmSwift
@testable import budget

class DetailsViewModelTests: XCTestCase {
    var realm: Realm!
    var viewModel: DetailsViewModel!

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
        viewModel = DetailsViewModel(dependency: AppDependency())
    }

    func testSuccessfulInit() {
        XCTAssertEqual(viewModel.categories.value.count, 1)
        XCTAssertEqual(viewModel.numberOfCategory, 1)
        XCTAssertEqual(viewModel.income.value, 0)
        XCTAssertEqual(viewModel.incomeNotBuget.value, -100)
        XCTAssertEqual(viewModel.categories.value[0].date.firstDayOfTheMonth, Date().firstDayOfTheMonth)
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM dd"
//        XCTAssertEqual(viewModel.currentDate.value, formatter.string(from: Date()))
//        XCTAssertEqual(viewModel.remainFund.value, 5000.00)
//        XCTAssertEqual(viewModel.categories.value.count, 1)
    }

    func testCellViewModel() {
        let cellViewModel = viewModel.cellViewModel(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(cellViewModel.title, "category1")
    }
}
