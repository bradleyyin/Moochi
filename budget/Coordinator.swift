//
//  Coordinator.swift
//  budget
//
//  Created by Bradley Yin on 6/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinating: class {
    var childCoordinators: [Coordinating] { get set }
}

extension Coordinating {
    /// Add a child coordinator to the parent
    func addChildCoordinator(childCoordinator: Coordinating) {
        self.childCoordinators.append(childCoordinator)
    }
    
    /// Remove a child coordinator from the parent
    func removeChildCoordinator(childCoordinator: Coordinating) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
}

class Coordinator: NSObject, Coordinating {
    var presenter: UIViewController
    var childCoordinators: [Coordinating] = []
    
    init(with presenter: UIViewController) {
        self.presenter = presenter
    }
    
    func cleanUpChildren() {
        self.childCoordinators = []
    }
}
