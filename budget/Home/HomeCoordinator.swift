//
//  HomeCoordinator.swift
//  budget
//
//  Created by Bradley Yin on 6/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    typealias Dependency = HasBudgetController
    let dependency: Dependency

    var navigationController: UINavigationController?

    lazy var homeViewController: HomeViewController = {
        let homeVC = HomeViewController(dependency: dependency)
        homeVC.delegate = self
        return homeVC
    }()

    init(with presenter: UIViewController, dependency: Dependency) {
        self.dependency = dependency
        super.init(with: presenter)
    }

}
