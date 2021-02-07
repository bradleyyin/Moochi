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


    var numberOfCategory: Int {
        return incompleteGoals.value?.count ?? 0
    }

    init(dependency: Dependency) {
        self.dependency = dependency
        super.init()
        fetchIncompleteGoals()
    }

    func fetchIncompleteGoals() {
        incompleteGoals.accept(dependency.budgetController.readIncompleteGoals())
    }

    func cellViewModel(at indexPath: IndexPath) -> GoalCellViewModel? {
        guard let goals = incompleteGoals.value else { return nil }
        let goal = goals[indexPath.row]
        let viewModel = GoalCellViewModel(goal: goal)
        return viewModel
    }
}
