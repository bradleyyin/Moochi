//
//  GoalViewModel.swift
//  budget
//
//  Created by Bradley Yin on 2/2/21.
//  Copyright © 2021 bradleyyin. All rights reserved.
//

import RxRelay
import RealmSwift
import RxSwift

final class GoalViewModel: NSObject {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator
    private let dependency: Dependency
    private let disposeBag = DisposeBag()

    let incompleteGoals = BehaviorRelay<Results<Goal>?>(value: nil)


    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchIncompleteGoals()
    }

    func fetchIncompleteGoals() {
        incompleteGoals.accept(dependency.budgetController.readIncompleteGoals())
    }
}
