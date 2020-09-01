//
//  AppCoordinator.swift
//  budget
//
//  Created by Bradley Yin on 6/10/20.
//  Copyright © 2020 bradleyyin. All rights reserved.
//
//test
import Foundation
import UIKit
import RealmSwift
import RxSwift

struct AppDependency: HasBudgetController, HasBudgetCalculator, HasMonthCalculator {
    let budgetController = BudgetController()
    let monthCalculator = MonthCalculator()
    let budgetCalculator =  BudgetCalculator()
}

class AppCoordinator: Coordinator {
    let dependency: AppDependency = AppDependency()

    
    
    //private lazy var bootstrap = BootstrapViewController(dependency: dependency)

    private var tabBarController: TabBarController?
    private var homeCoordinator: HomeCoordinator?

    private let disposeBag = DisposeBag()

    func start() {
        //startBootstrap()
        startMain()
    }
    
//    func startBootstrap() {
//        if let navigationController = presenter as? UINavigationController {
//            navigationController.setViewControllers([bootstrap], animated: false)
//            dependency.eventLogger.logImpressionEvent(eventName: Events.App.bootstrapStarted.rawValue)
//        }
//    }
//
//    func endBootstrap() {
//        if let navi = presenter as? UINavigationController,
//            navi.viewControllers.last == bootstrap {
//            if navi.presentedViewController == nil {
//                navi.delegate = self
//                navi.popViewController(animated: true)
//            } else {
//                var viewControllers = navi.viewControllers
//                viewControllers.removeLast()
//                navi.setViewControllers(viewControllers, animated: false)
//            }
//            dependency.eventLogger.logImpressionEvent(eventName: Events.App.bootstrapCompleted.rawValue)
//        }
//    }

    func startMain() {
            if tabBarController == nil {
                let home = HomeCoordinator(with: presenter, dependency: dependency)
                
                homeCoordinator = home

                let tabBar = TabBarController(viewControllers: [home.homeViewController, home.homeViewController, home.homeViewController, home.homeViewController, home.homeViewController])
                tabBar.actionDelegate = self
                tabBarController = tabBar

                if let navigationController = presenter as? UINavigationController {
                    navigationController.setViewControllers([tabBar], animated: false)
                }
            }
       
    }
    
    func clearChildCoordinators() {
        homeCoordinator = nil
    }
    
    func popToRoot() {
        if let navigationController = presenter as? UINavigationController {
            navigationController.dismiss(animated: false) {
                navigationController.popToRootViewController(animated: false)
            }
        }
    }
    
    func popToMain() {
        if let navigationController = presenter as? UINavigationController,
            let tabBar = tabBarController {
            navigationController.popToViewController(tabBar, animated: true)
            navigationController.dismiss(animated: true) { [tabBar] in
                navigationController.popToViewController(tabBar, animated: true)
            }
        } else {
            startMain()
        }
    }

    func switchTo(_ tab: TabItem) {
        tabBarController?.switchTo(tab)
    }
}

extension AppCoordinator: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if fromVC == bootstrap {
//            let animator = ShutterRevealAnimator()
//            animator.transitionMode = .present
//            animator.startingPoint = CGPoint.init(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
//            return animator
//        } else {
//            return nil
//        }
//    }
}

extension AppCoordinator: TabBarActionDelegate {
    func didTapTab(item: TabItem, isCurrentTab: Bool) {
        switch item {
        case .home:
            if isCurrentTab {
                //homeCoordinator?.homeViewController.scrollsToTop(animated: true)
            }
        case .details:
            break
        case .add:
            if isCurrentTab {
                //theiaActivityCoordinator?.activityViewController.scrollsToTop(animated: true)
            }
        case .calendar:
            if isCurrentTab {
                //theiaProfileCoordinator?.profileViewController.scrollsToTop(animated: true)
            }
        case .goal:
            if isCurrentTab {
                
            }
        }
    }

//    func didStartStudio() {
//        let studioCoordinator = TheiaStudioCoordinator(with: presenter, dependency: dependency)
//        studioCoordinator.delegate = self
//        studioCoordinator.start(nil, tryonIDArray: [], currentIndex: 0)
//        addChildCoordinator(childCoordinator: studioCoordinator)
//    }
}
