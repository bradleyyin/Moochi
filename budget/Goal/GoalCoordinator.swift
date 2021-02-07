//
//  GoalCoordinator.swift
//  budget
//
//  Created by Bradley Yin on 2/6/21.
//  Copyright © 2021 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class GoalCoordinator: Coordinator {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    let dependency: Dependency

    var navigationController: UINavigationController?

    lazy var goalViewController: GoalViewController = {
        let detailsVC = GoalViewController(dependency: dependency)
        detailsVC.delegate = self
        return detailsVC
    }()

    init(with presenter: UIViewController, dependency: Dependency) {
        self.dependency = dependency
        super.init(with: presenter)
    }
}

extension GoalCoordinator: GoalViewControllerDelegate, AddCategoriesViewControllerDelegate {
    func didTapClose() {
        presenter.dismiss(animated: true, completion: nil)
    }

    func addButtonTapped() {
        let vc = AddCategoriesViewController(category: nil, dependency: dependency)
        vc.delegate = self
        presenter.present(vc, animated: true)
    }

    func goalTapped(goal: Goal) {
//        let vc = ChartViewController(category: category, dependency: dependency)
//
//        //vc.delegate = self
//        if let nav = presenter as? UINavigationController {
//            nav.pushViewController(vc, animated: true)
//        }
    }

//    func editCategoryTapped(category: Category) {
//        let vc = AddCategoriesViewController(category: category, dependency: dependency)
//        vc.delegate = self
//        presenter.present(vc, animated: true)
//    }
}
