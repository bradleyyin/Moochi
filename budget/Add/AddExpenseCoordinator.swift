//
//  AddExpenseCoordinator.swift
//  budget
//
//  Created by Bradley Yin on 9/7/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

protocol AddExpenseCoordinatorDelegate: class {
    func didDismissAdd(_ coordinator: Coordinator)
}

class AddExpenseCoordinator: Coordinator {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    let dependency: Dependency
    weak var delegate: AddExpenseCoordinatorDelegate?

    var navigationController: UINavigationController?

    lazy var addExpenseViewController: AddEntryViewController = {
        let addVC = AddEntryViewController(expense: nil, dependency: dependency)
        addVC.modalPresentationStyle = .overFullScreen
        //addVC.delegate = self
        return addVC
    }()

    init(with presenter: UIViewController, dependency: Dependency) {
        self.dependency = dependency
        super.init(with: presenter)
    }

    func start() {
        presenter.present(addExpenseViewController, animated: true)
    }
}

extension AddExpenseCoordinator: HomeViewControllerDelegate {

}
