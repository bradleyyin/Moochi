//
//  CalendarCoordinator.swift
//  budget
//
//  Created by Bradley Yin on 11/21/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class CalendarCoordinator: Coordinator {
    typealias Dependency = HasBudgetController & HasBudgetCalculator & HasMonthCalculator

    let dependency: Dependency

    var navigationController: UINavigationController?

    lazy var calendarViewController: CalendarViewController = {
        let calendarVC = CalendarViewController(dependency: dependency)
        calendarVC.delegate = self
        return calendarVC
    }()

    init(with presenter: UIViewController, dependency: Dependency) {
        self.dependency = dependency
        super.init(with: presenter)
    }
}

extension CalendarCoordinator: CalendarViewControllerDelegate {
    
}
