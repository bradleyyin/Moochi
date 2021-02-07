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

extension DetailsCoordinator: DetailsViewControllerDelegate, AddCategoriesViewControllerDelegate {
    func chartButtonTapped() {
        let category = Category()
        let vc = ChartViewController(category: category, dependency: dependency)
        presenter.present(vc, animated: true)
    }
    
    func didTapClose() {
        presenter.dismiss(animated: true, completion: nil)
    }

    func addButtonTapped() {
        let vc = AddCategoriesViewController(category: nil, dependency: dependency)
        vc.delegate = self
        presenter.present(vc, animated: true)
    }

    func categoryTapped(category: Category) {
        let vc = ChartViewController(category: category, dependency: dependency)

        //vc.delegate = self
        if let nav = presenter as? UINavigationController {
            nav.pushViewController(vc, animated: true)
        }
    }

    func editCategoryTapped(category: Category) {
        let vc = AddCategoriesViewController(category: category, dependency: dependency)
        vc.delegate = self
        presenter.present(vc, animated: true)
    }
}
