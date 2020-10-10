//
//  DetailsCoordinator.swift
//  budget
//
//  Created by Bradley Yin on 10/9/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class DetailsCoordinator: Coordinator {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    let dependency: Dependency

    var navigationController: UINavigationController?

    lazy var detailsViewController: DetailsViewController = {
        let detailsVC = DetailsViewController(dependency: dependency)
        detailsVC.delegate = self
        return detailsVC
    }()

    init(with presenter: UIViewController, dependency: Dependency) {
        self.dependency = dependency
        super.init(with: presenter)
    }
}

extension DetailsCoordinator: DetailsViewControllerDelegate {

}
