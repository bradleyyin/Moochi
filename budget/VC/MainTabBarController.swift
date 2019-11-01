//
//  MainTabBarController.swift
//  budget
//
//  Created by Bradley Yin on 10/12/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    let budgetController = BudgetController()
    let budgetCalculator = BudgetCalculator()
    
    private var mainViewController: MainViewController {
        let mainVC = MainViewController()
        mainVC.budgetController = budgetController
        mainVC.budgetCalculator = budgetCalculator
        mainVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "home"), tag: 0)
        return mainVC
    }
    
    private var detailsViewController: DetailsViewController {
        let detailsVC = DetailsViewController()
        detailsVC.budgetController = budgetController
        detailsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "details"), tag: 1)
        return detailsVC
    }
    
    private var expenseViewController: ExpenseViewController {
        let expenseVC = ExpenseViewController()
        expenseVC.budgetController = budgetController
        expenseVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "calendar"), tag: 2)
        return expenseVC
    }
    
//    private var receiptAlbumViewController: ReceiptAlbumViewController {
//        let receiptAlbumVC = ReceiptAlbumViewController()
//        receiptAlbumVC.budgetController = budgetController
//        receiptAlbumVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "album"), tag: 3)
//        return receiptAlbumVC
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupAppearance()
    }
    
    private func setupViewControllers() {
        
        let expensesNav = UINavigationController(rootViewController: expenseViewController)
        expensesNav.isNavigationBarHidden = true
        
        //let receiptNav = UINavigationController(rootViewController: receiptAlbumViewController)
        //receiptNav.isNavigationBarHidden = true
        
        let detailsNav = UINavigationController(rootViewController: detailsViewController)
        detailsNav.isNavigationBarHidden = true
   
        self.viewControllers = [mainViewController, detailsNav, expensesNav]
    }
    
    private func setupAppearance() {
        if traitCollection.userInterfaceStyle == .light {
            self.tabBar.barTintColor = .clear
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
            self.tabBar.tintColor = .black
            self.tabBar.unselectedItemTintColor = superLightGray
        } else {
            self.tabBar.barTintColor = .clear
            self.tabBar.shadowImage = UIImage()
            self.tabBar.backgroundImage = UIImage()
            self.tabBar.tintColor = .white
            self.tabBar.unselectedItemTintColor = .darkGray
        }
        
    }
}
