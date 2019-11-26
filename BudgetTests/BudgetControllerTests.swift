//
//  BudgetTests.swift
//  BudgetTests
//
//  Created by Bradley Yin on 11/7/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

//swiftlint:disable force_try

import XCTest
import CoreData
@testable import budget

class BudgetControllerTests: XCTestCase {
    let budgetController = BudgetController()

    func testCreateNewExpense() {
        budgetController.createNewExpense(name: "test", amount: 10.0, date: Date(), category: nil, image: nil)
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        let expenses = try! CoreDataStack.shared.mainContext.fetch(request)
        XCTAssert(expenses.contains(where: { $0.name == "test" }))
    }

}
