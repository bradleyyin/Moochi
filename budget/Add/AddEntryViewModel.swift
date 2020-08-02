//
//  AddEntryViewModel.swift
//  budget
//
//  Created by Bradley Yin on 6/19/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxRealm
import RxSwift

final class AddEntryViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency

    let categories = BehaviorRelay<[String]>(value: [])
    
    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchCategories()
    }

    func refresh() {
        fetchCategories()
    }
    
    private func fetchCategories() {
        let categories = dependency.budgetController.readCategories()
        var nameArray: [String] = ["uncategorized"]
        for category in categories {
            nameArray.append(category.name)
        }
        self.categories.accept(nameArray)
    }
}
